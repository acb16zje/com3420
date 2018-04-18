require 'irb'

class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]
  authorize_resource

  # Booking status {1: Pending, 2: Accepted, 3: Ongoing, 4: Completed,
  # 5: Rejected, 6: Cancelled, 7: Late}

  # GET /bookings
  def index
    @bookings = Booking.where("user_id = ?", current_user.id)
  end

  # GET /bookings/1
  def show
  end

  # GET /bookings/requests
  def requests
    @bookings = Booking.joins(:item).where("items.user_id = ? and bookings.status = 1", current_user.id)
  end

  # GET /bookings/accepted
  def accepted
    @bookings = Booking.joins(:item).where("items.user_id = ? and bookings.status = 2", current_user.id)
  end

  # GET /bookings/ongoing
  def ongoing
    # Get current date/time

    @bookings = Booking.joins(:item).where("items.user_id = ? and bookings.status = 3", current_user.id)
  end

  # GET /bookings/completed
  def completed
    # @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and (bookings.status = 4 or bookings.status = 6)", current_user.id)
    @bookings = Booking.joins(:item).where("items.user_id = ? and (bookings.status = 4 or bookings.status = 6)", current_user.id)
  end

  # GET /bookings/rejected
  def rejected
    @bookings = Booking.joins(:item).where("items.user_id = ? and bookings.status = 5", current_user.id)
  end

  # GET /bookings/late
  def late
    @bookings = Booking.joins(:item).where("items.user_id = ? and bookings.status = 7", current_user.id)
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @item = Item.find_by_id(params[:item_id])

    @peripherals = @item.getItemPeripherals

    gon.initial_disable_dates = [fully_booked_days_single, fully_booked_days_multi].reduce([], :concat)
    gon.max_end_date = max_end_date
  end

  # GET /bookings/1/edit
  def edit
    @item = Item.find_by_id(@booking.item_id)

    if !@item.parent_asset_serial.blank?
      @parent = Item.where('serial = ?', @item.parent_asset_serial).first
    end
  end

  # POST /bookings
  def create
    @booking = Booking.new(booking_params)
    main_item = Item.find(params[:booking][:main_item])

    # Set booking fields which aren't filled by form
    @booking.start_datetime = @booking.start_date.to_s + ' ' + @booking.start_time.to_s
    @booking.end_datetime = @booking.end_date.to_s + ' ' + @booking.end_time.to_s
    @booking.next_location = params[:booking][:next_location].titleize

    # Make sure not nil for unrequired field.
    if params[:booking][:reason].blank?
      @booking.reason = "None"
    end

    #Set booking status depending upon its creator
    if main_item.user_id == current_user.id
      @booking.status = 2
    else
      Notification.create(recipient: @booking.item.user, action: "requested", notifiable: @booking, context: "AM")
      @booking.status = 1
    end

    b_array = Item.where(id: (params[:booking][:booking_peripheral_items])) + [main_item]
    query = b_array.all? { |i| booking_validation(i.id, @booking.start_datetime, @booking.end_datetime)}

    if (query) && @booking.save
      puts "IN IF STATEMENT"
      bookingitems_to_save = p_array.map {|i| BookingItem.new(booking: @booking, item: i)}
      puts bookingitems_to_save
      if bookingitems_to_save.each(&:save)
        UserMailer.user_booking_requested(@booking).deliver
        UserMailer.manager_booking_requested(@booking).deliver
        redirect_to bookings_path, notice: 'Booking was successfully created.'
      else
        redirect_to new_item_booking_path(item_id: main_item.id), notice: 'There was an issue adding the chosen peripherals'
      end
    else
      redirect_to new_item_booking_path(item_id:  main_item.id), notice: 'Chosen timeslot conflicts with other bookings.'
    end
  end

  # PATCH/PUT /bookings/1
  def update
    if @booking.update(booking_params)
      if @booking.status == 2
        Notification.create(recipient: @booking.user, action: "approved", notifiable: @booking, context: "U")
        UserMailer.booking_approved(@booking).deliver
      elsif @booking.status == 5
        Notification.create(recipient: @booking.user, action: "rejected", notifiable: @booking, context: "U")
        UserMailer.booking_rejected(@booking).deliver
      end

      redirect_to requests_bookings_path, notice: 'Booking was successfully updated.'
    end
  end

  # Set booking as cancelled
  def set_booking_cancelled
    @booking = Booking.find(params[:id])
    @booking.status = 6
    if @booking.save
      Notification.create(recipient: @booking.user, action: "cancelled", notifiable: @booking, context: "AM")
      UserMailer.manager_booking_cancelled(@booking).deliver
      redirect_to bookings_path, notice: 'Booking was successfully cancelled.'
    end
  end

  # GET /bookings/1/booking_returned
  def booking_returned
    @booking = Booking.find_by_id(params[:id])
    @item = Item.find_by_id(@booking.item.id)
  end

  # PUT /bookings/1/set_booking_returned
  def set_booking_returned
    @booking = Booking.find(params[:id])
    @booking.status = 4

    if @booking.save
      Notification.create(recipient: @booking.user, action: "returned", notifiable: @booking, context: "AM")
      UserMailer.manager_asset_returned(@booking).deliver

      item = Item.find_by_id(@booking.item.id)
      item.condition = params[:item][:condition]
      item.condition_info = params[:item][:condition_info]

      if item.condition == "Missing" or item.condition == "Damaged"
        Notification.create(recipient: item.user, action: "reported", notifiable: item, context: "AM")
        UserMailer.manager_asset_issue(@booking.user, @booking.item).deliver
      end

      item.save

      if item.user_id == current_user.id
        redirect_to manager_items_path(:user_id => current_user.id)
      elsif item.condition == "Damaged" or item.condition == "Missing"
        redirect_to item, notice: 'We have logged the issue and your item has been returned'
      else
        redirect_to item, notice: 'Thank you. Your item has been returned'
      end
    end
  end

  def start_date
    data = {
      :max_end_date => max_end_date(params[:start_date]),
      :disable_start_time => disable_start_time(params[:start_date]),
    }

    render :json => data
  end

  def end_date
    data = {
      :max_end_time => max_end_time(params[:start_date], params[:end_date], params[:start_time])
    }

    render :json => data
  end

  def peripherals
    @item = Item.find_by_id(params[:item_id])

    @peripherals = get_allowed_peripherals(params[:start_datetime],params[:end_datetime],params[:item_id])

    respond_to do |format|
      format.json {
        render :json => @peripherals
      }
    end
  end

  private

  def get_allowed_peripherals(start_datetime,end_datetime,item_id)
    item = Item.find_by_id(item_id)
    peripherals = item.getItemPeripherals
    allowed_peripherals = []
    peripherals.each do |peripheral|
      if booking_validation(peripheral.id,start_datetime,end_datetime)
        allowed_peripherals.append(peripheral)
      end
    end

    return allowed_peripherals
  end

  def booking_validation(item_id, start_datetime, end_datetime)
    query = Booking.where(
      "(status = 2 OR status = 3)
      AND item_id = '#{item_id}'
      AND (
        (start_datetime < CAST ('#{start_datetime}' AS TIMESTAMP)
        AND end_datetime > CAST ('#{start_datetime}' AS TIMESTAMP))

        OR (start_datetime > CAST ('#{start_datetime}' AS TIMESTAMP)
            AND start_datetime < CAST ('#{end_datetime}' AS TIMESTAMP))

        OR (start_datetime = CAST ('#{start_datetime}' AS TIMESTAMP)
            AND end_datetime = CAST ('#{end_datetime}' AS TIMESTAMP))
      )"
    ).first

    return query.blank?
  end

  # Fully booked days in a single booking
  def fully_booked_days_single
    date_to_disable = []
    bookings = Booking.where(
      "(status = 2 OR status = 3)
      AND item_id = ?
      AND start_date <> end_date
      AND ((start_time = '2000-01-01 00:00:00 UTC'
          AND end_time = '2000-01-01 00:00:00 UTC'
          AND DATE_PART('day', to_char(end_datetime, 'YYYY-MM-DD HH24:MI:SS')::timestamp - to_char(start_datetime, 'YYYY-MM-DD HH24:MI:SS')::timestamp) = 1)
        OR
          (DATE_PART('day', to_char(end_datetime, 'YYYY-MM-DD HH24:MI:SS')::timestamp - to_char(start_datetime, 'YYYY-MM-DD HH24:MI:SS')::timestamp) > 1))", params[:item_id]
    )

    bookings.each do |booking|
      start_date = Date.parse(booking.start_date.to_s)
      end_date = Date.parse(booking.end_date.to_s)
      start_time = DateTime.parse(booking.start_datetime.to_s)

      date_array = (start_date...end_date).map(&:to_s)

      # Single booking multiple days
      if date_array.length > 1
        # Include the start date if start time is 12:00 AM
        if (start_time.hour.eql? 0) && (start_time.min.eql? 0) ||
           (DateTime.now > booking.start_datetime)
          #  (DateTime.now.hour > start_time.hour) ||
          #  (DateTime.now.hour == start_time.hour && DateTime.now.min > start_time.min)
          date_array = date_array[0..-1]
        else
          date_array = date_array[1..-1]
        end
      end

      # Split into [year, month, day]
      date_array = date_array.map { |n| n.split('-') }

      # Datepicker month format is jan = 0, feb = 1, mar = 2...
      date_array = date_array.map { |n| n[0] = n[0], n[1] = n[1].to_i - 1, n[2] = n[2] }

      date_to_disable.concat(date_array)
    end

    return date_to_disable
  end

  # Fully booked days in a multiple booking
  def fully_booked_days_multi
    date_to_disable = []

    bookings = Booking.find_by_sql [
      "WITH RECURSIVE linked_bookings AS (
          SELECT A.start_date AS start_date,
          A.start_datetime AS start_datetime,
          B.end_date AS end_date,
          B.end_datetime AS end_datetime
          FROM bookings A, bookings B
          WHERE (A.status = 2 OR A.status = 3)
          AND A.item_id = ?
          AND A.end_datetime = B.start_datetime
          AND A.id <> B.id
        UNION ALL
          SELECT p.start_date, p.start_datetime, pr.end_date, pr.end_datetime
          FROM bookings p, linked_bookings pr
          WHERE p.end_datetime = pr.start_datetime
      )
      SELECT start_date, start_datetime, end_date, end_datetime FROM linked_bookings", params[:item_id]]

    bookings.each do |booking|
      start_date = Date.parse(booking.start_date.to_s)
      end_date = Date.parse(booking.end_date.to_s)
      start_time = DateTime.parse(booking.start_datetime.to_s)

      # Multiple booking across many days or Multiple bookings on single day
      if (end_date - start_date).to_i > 1 || ((start_time.hour.eql? 0) && (start_time.min.eql? 0))
        date_array = (start_date...end_date).map(&:to_s)

        if date_array.length > 1
          # Include the start date if start time is 12:00 AM
          if (start_time.hour.eql? 0) && (start_time.min.eql? 0)
            date_array = date_array[0..-1]
          else
            date_array = date_array[1..-1]
          end
        end

        # Split into [year, month, day]
        date_array = date_array.map { |n| n.split('-') }

        # Datepicker month format is jan = 0, feb = 1, mar = 2...
        date_array = date_array.map { |n| n[0] = n[0], n[1] = n[1].to_i - 1, n[2] = n[2] }

        date_to_disable.concat(date_array)
      end
    end

    return date_to_disable
  end

  # Maximum selectable end date
  def max_end_date(start_date = nil)
    date_array = []

    if start_date.nil?
      start_date = Date.today.strftime("%Y-%m-%d")
    else
      start_date = Date.parse(start_date)
    end

    booking = Booking.where(
      "(status = 2 OR status = 3)
      AND item_id = ?
      AND start_date >= CAST('#{start_date}' AS DATE)", params[:item_id]
    ).minimum(:start_date)

    if !booking.blank?
      # Split into [year, month, day]
      booking = booking.strftime("%Y-%m-%d").split('-')

      # Datepicker month format is jan = 0, feb = 1, mar = 2...
      booking[1] = booking[1].to_i - 1

      date_array.concat(booking)
    end

    return date_array
  end

  # Disable unavailable start time
  def disable_start_time(start_date)
    time_to_disable = []

    start_date = Date.parse(start_date)

    bookings = Booking.where(
      "(status = 2 OR status = 3)
      AND item_id = ?
      AND (start_date = CAST('#{start_date}' AS DATE)
      OR end_date = CAST('#{start_date}' AS DATE))", params[:item_id]
    ).select(:start_datetime, :end_datetime)

    bookings.each do |booking|
      start_time = DateTime.parse(booking.start_datetime.to_s)
      end_time = DateTime.parse(booking.end_datetime.to_s) - 10.minutes

      # Selected start date is booked as start date
      if start_time.strftime("%Y-%m-%d").eql? start_date.to_s
        # Start date not equal to end date
        if end_time.day - start_time.day > 0
          time_to_disable.append({from: ["#{start_time.hour}", "#{start_time.min}"], to: [23, 50]})
        else
          # Start and end on the same day
          time_to_disable.append(
            {from: ["#{start_time.hour}", "#{start_time.min}"], to: ["#{end_time.hour}", "#{end_time.min}"]},
          )
        end
      else
        # Selected start date is booked as end date
        if end_time.day - start_time.day > 0
          time_to_disable.append({from: [0, 0], to: ["#{end_time.hour}", "#{end_time.min}"]})
        end
      end
    end

    return time_to_disable
  end

  # Maximum selectable end time
  def max_end_time(start_date, end_date, start_time)
    time_array = []

    start_time = DateTime.parse(start_time).strftime("%H:%M")

    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    if start_date < end_date
      booking = Booking.where(
        "(status = 2 OR status = 3)
        AND item_id = ?
        AND start_date = CAST('#{end_date}' AS DATE)", params[:item_id]
      ).minimum(:start_time)

      if !booking.blank?
        time_array = [booking.hour, booking.min]
      end
    else
      booking = Booking.where(
        "(status = 2 OR status = 3)
        AND item_id = ?
        AND start_date = CAST('#{start_date}' AS DATE)", params[:item_id]
      ).minimum(:start_time)

      if !booking.blank? && start_time < booking.strftime("%H:%M")
        time_array = [booking.hour, booking.min]
      end
    end

    return time_array
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def booking_params
    params.require(:booking).permit!
  end
end
