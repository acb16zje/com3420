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
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and bookings.status = 1", current_user.id)
  end

  # GET /bookings/accepted
  def accepted
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and bookings.status = 2", current_user.id)
  end

  # GET /bookings/ongoing
  def ongoing
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and bookings.status = 3", current_user.id)
  end

  # GET /bookings/completed
  def completed
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and (bookings.status = 4 or bookings.status = 6)", current_user.id)
  end

  # GET /bookings/rejected
  def rejected
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and bookings.status = 5", current_user.id)
  end

  # Convert the datetime object to a date string to block
  def get_date_array(date_time)
    block_date = date_time.strftime("%Y-%m-%d").split('-')
    block_date[1] = (block_date[1].to_i - 1).to_s
    return block_date
  end

  # Check if the provided date time is before 9 AM
  def check_before_date(datetime)
    if DateTime.parse(datetime.to_time.to_s) <= DateTime.new(datetime.year, datetime.month, datetime.day, 0, 0, 0)
      return true
    end
    return false
  end

  # Check if the provided date time is after 5 PM
  def check_after_date(datetime)
    if DateTime.parse(datetime.to_time.to_s) >= DateTime.new(datetime.year, datetime.month, datetime.day + 1, 0, 0, 0)
      return true
    end
    return false
  end

  def get_accepted_dates(block_dates, selected_date)
    allowed_dates = [true]
    now = selected_date
    first_block_date_array = block_dates[0]
    first_block_date = DateTime.new(first_block_date_array[0].to_i, (first_block_date_array[1].to_i + 1), first_block_date_array[2].to_i, 0, 0, 0)

    (Date.parse(now.to_s)..Date.parse(first_block_date.to_s)).each do |date|
      allowed_dates.append(get_date_array(date))
    end

    return allowed_dates - block_dates
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @item = Item.find_by_id(params[:item_id])
    bookings = Booking.where("bookings.status = 2 or bookings.status = 3")
    block_dates = []
    check_dates = []

    bookings.each do |booking|
      # If a single booking fills in the entire day
      if (booking.start_date).eql? booking.end_date
        if check_before_date(booking.start_time) && check_after_date(booking.end_time)
          block_dates.append(get_date_array(booking.start_datetime))
        end
        # If a single booking that spans 2 days, would fill up either day
      elsif (booking.end_date - booking.start_date).to_i == 1
        if check_before_date(booking.start_time)
          block_dates.append(get_date_array(booking.start_datetime))
        end
        if check_after_date(booking.end_time)
          block_dates.append(get_date_array(booking.end_datetime))
        end
        # If a booking that spans multiple days, it fills up the days in between, and checks if it fills up the start and end date
      elsif (booking.end_date - booking.start_date).to_i > 1
        ((Date.parse(booking.start_datetime.to_s) + 1)..(Date.parse(booking.end_datetime.to_s) - 1)).each do |date|
          block_dates.append(get_date_array(date))
        end

        if check_before_date(booking.start_time)
          block_dates.append(get_date_array(booking.start_datetime))
        end

        if check_after_date(booking.end_time)
          block_dates.append(get_date_array(booking.end_datetime))
        end
      end

      check_dates.append(booking.start_datetime)
      check_dates.append(booking.end_datetime)
    end

    check_dates.sort!

    i = 0

    while i < check_dates.length - 2
      # so the start count will point to the correct day
      start_count = i + 1
      end_count = i + 1

      prev_day = false

      # Checks for consecutive times and gets the the end of the streak
      while (check_dates[start_count].to_time - check_dates[end_count + 1].to_time).to_i == 0
        start_count += 2
        end_count += 2
        break if check_dates[end_count + 1].nil?
      end

      # Checks if the first time of the section is connected to a booking on the previous day
      if (Date.parse(check_dates[end_count].to_time.to_s) - Date.parse(check_dates[i].to_time.to_s)) > 0
        prev_day = true
      end

      # If it is not connected to the previous day, then check whether the start time and end time of the consecutive bookings fills the day
      if !prev_day
        if check_before_date(check_dates[i]) && check_after_date(check_dates[end_count])
          block_dates.append(get_date_array(check_dates[i]))
        end
      else
        # If it is connected, then block dates in between start and end
        ((Date.parse(check_dates[i].to_time.to_s) + 1)..(Date.parse(check_dates[end_count].to_s) - 1)).each do |date|
          block_dates.append(get_date_array(date))
        end
        # Check whether start date needs to be blocked
        if check_before_date(check_dates[i])
          block_dates.append(get_date_array(check_dates[i]))
        end
        # Check whether end date needs to be blocked
        if check_after_date(check_dates[end_count])
          block_dates.append(check_dates[end_count])
        end
      end

      i = end_count + 1
    end

    gon.block_start_dates = block_dates
    gon.block_end_dates = block_dates

    # Dynamic time blocking #
    # If start date is changed, then check for times that needed to be blocked
    if !bookings.nil? && !bookings.blank?
      if !params[:start_date].blank?
        # Get what end dates are accepted starting from selected start date, till date of first booking
        # E.g If start date is 23 March 2018, the first booking after that date is 29 March 2018, accepted dates is 23-28 March 2018
        start_date_array = get_date_array(params[:start_date])
        gon.block_end_dates = get_accepted_dates(block_dates, DateTime.new(start_date_array[0], start_date_array[1], start_date_array[2], 0, 0, 0))
        # Get what times to be blocked for selected date
        gon.block_start_time = get_block_times(bookings, params[:start_date])

        data = {
          :block_start_time => gon.block_start_time,
        }

        render :json => data
        # If end date is changed, then check for times that needed to be blocked
      elsif !params[:end_date].blank?
        gon.block_end_time = get_block_times(bookings, params[:end_date])

        data = {
          :block_end_time => gon.block_end_time,
        }

        render :json => data
        # If the page just refreshed, use todays values to check for times to be blocked
      else
        date_s = DateTime.now
        # Get what end dates are accepted starting from today, till date of first booking
        # E.g If today is 23 March 2018, the first booking after that date is 29 March 2018, accepted dates is 23-28 March 2018
        gon.block_end_dates = get_accepted_dates(block_dates, date_s)

        date_s = date_s.day.to_s + " " + Date::MONTHNAMES[date_s.month] + " " + date_s.year.to_s
        gon.block_start_time = get_block_times(bookings, date_s)
        gon.block_end_time = get_block_times(bookings, date_s)
      end
    end
  end

  # Get the times to be blocked on the provided date
  def get_block_times(bookings, today)
    block_times = []
    check_times = []

    # To get the single booking where it may be connected from a previous day
    block_bookings = bookings.where("bookings.end_date = ? and bookings.start_date != ?", today, today)
    if !block_bookings.nil? && !block_bookings.blank?
      block_bookings.each do |booking|
        check_times.append(booking.start_datetime)
        check_times.append(booking.end_datetime)
      end
    end

    block_bookings = bookings.where("bookings.start_date = ?", today)
    block_bookings.each do |booking|
      check_times.append(booking.start_datetime)
      check_times.append(booking.end_datetime)
    end

    i = 0
    while i < check_times.length - 1
      start_count = i + 1
      end_count = i + 1

      while !check_times[end_count + 1].nil? && (check_times[start_count].to_time - check_times[end_count + 1].to_time).to_i == 0
        start_count += 2
        end_count += 2
      end

      # The start of the time chunk to be blocked
      temp_start_time = check_times[i]
      # The end of the time chunk to be blocked
      temp_end_time = check_times[end_count]

      # Comparing the difference between today and the end date
      today_end_comp = (DateTime.parse(today + " 09:00:00 AM") - DateTime.new(temp_end_time.year, temp_end_time.month, temp_end_time.day, 9, 0, 0)).to_i
      # Comparing the difference between the start and the end date
      start_end_comp = (DateTime.new(temp_start_time.year, temp_start_time.month, temp_start_time.day, 9, 0, 0) - DateTime.new(temp_end_time.year, temp_end_time.month, temp_end_time.day, 9, 0, 0)).to_i

      # If the end date is on a day after today
      if today_end_comp < 0
        # Ends the block chunk on the end of the day
        temp_end_time = DateTime.new(temp_start_time.year, temp_start_time.month, temp_start_time.day, 23, 50, 0)
      else
        # If the start date is before the end date
        if start_end_comp < 0
          # Start the block chunk at the start of the end date
          temp_start_time = DateTime.new(temp_end_time.year, temp_end_time.month, temp_end_time.day, 0, 0, 0)
          block_times.append([0, 0])
        end
      end

      temp_start_time += 10.minutes
      # A loop to add the time strings to be blocked from the start to end time, does not add 5 PM to the blocked time
      while (temp_start_time.to_time - temp_end_time.to_time).to_i < 0 && !check_after_date(temp_start_time)
        block_time_string = temp_start_time.strftime("%H-%M").split('-')
        block_times.append([block_time_string[0], block_time_string[1]])
        # So the next time string to be blocked will be 10 minutes after
        temp_start_time += 10.minutes
      end
      # If the booking ended the next day, block 5PM
      if today_end_comp < 0
        block_time_string = temp_start_time.strftime("%H-%M").split('-')
        block_times.append([block_time_string[0], block_time_string[1]])
      end

      i = end_count + 1
    end

    return block_times
  end

  # GET /bookings/1/edit
  def edit
    @item = Item.find_by_id(@booking.item_id)
  end

  # POST /bookings
  def create
    @booking = Booking.new(booking_params)

    @booking.start_datetime = @booking.start_date.to_s + ' ' + @booking.start_time.to_s
    @booking.end_datetime = @booking.end_date.to_s + ' ' + @booking.end_time.to_s

    item = Item.find_by_id(@booking.item_id)
    if item.user_id == current_user.id
      @booking.status = 2
    else
      Notification.create(recipient: @booking.item.user, action: "requested", notifiable: @booking, context: "AM")
      UserMailer.user_booking_requested(User.find(@booking.user_id), Item.find(@booking.item_id)).deliver
      UserMailer.manager_booking_requested(User.find(@booking.user_id), Item.find(@booking.item_id), User.find((Item.find(@booking.item_id)).user_id), @booking).deliver
      @booking.status = 1
    end

    if @booking.save
      redirect_to bookings_path, notice: 'Booking was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bookings/1
  def update
    if @booking.update(booking_params)
      if @booking.status == 2
        Notification.create(recipient: @booking.user, action: "approved", notifiable: @booking, context: "U")
        UserMailer.booking_approved(User.find(@booking.user_id), Item.find(@booking.item_id)).deliver
      elsif @booking.status == 5
        Notification.create(recipient: @booking.user, action: "rejected", notifiable: @booking, context: "U")
        UserMailer.booking_rejected(User.find(@booking.user_id), Item.find(@booking.item_id)).deliver
      end

      redirect_to requests_bookings_path, notice: 'Booking was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: 'Booking was successfully destroyed.'
  end

  # Set booking as cancelled
  def set_booking_cancelled
    @booking = Booking.find(params[:id])
    @booking.status = 6
    if @booking.save
      Notification.create(recipient: @booking.user, action: "cancelled", notifiable: @booking, context: "AM")
      UserMailer.manager_booking_cancelled(User.find(@booking.user_id), Item.find(@booking.item_id), User.find((Item.find(@booking.item_id)).user_id), @booking).deliver
      redirect_to bookings_path, notice: 'Booking was successfully cancelled.'
    else
      redirect_to bookings_path, notice: 'Could not cancel booking.'
    end
  end

  # Set booking as returned
  def set_booking_returned
    @booking = Booking.find(params[:id])
    @booking.status = 4
    if @booking.save
      Notification.create(recipient: @booking.user, action: "returned", notifiable: @booking, context: "AM")
      UserMailer.manager_asset_returned(User.find(@booking.user_id), Item.find(@booking.item_id), User.find((Item.find(@booking.item_id)).user_id)).deliver
      redirect_to bookings_path, notice: 'Item marked as returned'
    else
      redirect_to bookings_path, notice: 'Could not be returned'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def booking_params
    params.require(:booking).permit!
  end
end
