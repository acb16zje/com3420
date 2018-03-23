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
    # Get current date/time
    to_update = Booking.where('status = 2 AND start_datetime < ?', DateTime.now)
    to_update.each do |b|
      Notification.create(recipient: b.user, action: "started", notifiable: b, context: "U")
      Notification.create(recipient: b.item.user, action: "started", notifiable: b, context: "AM")
      UserMailer.booking_ongoing(User.find(b.user_id), Item.find(b.item_id)).deliver
      b.status = 3
      b.save
    end

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

  # GET /bookings/new
  def new
    @booking = Booking.new
    @item = Item.find_by_id(params[:item_id])
    bookings = Booking.where("bookings.status = 2 or bookings.status = 3")

    set_of_dates = get_single_block_dates(bookings)
    block_dates = set_of_dates[0]
    check_dates = set_of_dates[1]

    block_dates = get_cons_block_dates(check_dates, block_dates)
    now = DateTime.now
    if (now > DateTime.new(now.year, now.month, now.day, 23, 50, 0))
      block_dates.append(get_array_from_date(now))
    end

    gon.block_start_dates = block_dates
    gon.block_end_dates = block_dates
    gon.max_end_date = get_min_date(block_dates, DateTime.now)
    if gon.max_end_date.blank? || gon.max_end_date.nil? || check_before_today(get_date_from_array(gon.max_end_date))
      gon.max_end_date = ''
    end
    # Dynamic time blocking #
    # If start date is changed, then check for times that needed to be blocked
    if !bookings.blank? && !bookings.nil?
      if !params[:start_date].blank?

        # If the the earliest booking is before the selected start date, no max is set for the end date
        gon.max_end_date = get_min_date(block_dates, get_date_from_string(params[:start_date]))
        if gon.max_end_date.blank? || gon.max_end_date.nil? || get_date_from_string(params[:start_date]) > get_date_from_array(gon.max_end_date)
          gon.max_end_date = ''
        end

        # Get what times to be blocked for selected date
        gon.block_start_time = get_block_times(bookings, params[:start_date])
        if gon.block_start_time.nil? || gon.block_start_time.blank?
          gon.block_end_time = ''
        else
          gon.block_end_time = get_max_end_time(gon.block_start_time[0])
        end
        data = {
          :end_date => get_array_from_date(get_date_from_string(params[:start_date])),
          :max_end_date => gon.max_end_date,
          :block_start_time => gon.block_start_time,
          :block_end_time => gon.block_end_time,
        }

        render :json => data
        # If end date is changed, then check for times that needed to be blocked
      elsif !params[:end_date].blank?
        gon.block_end_time = get_block_times(bookings, params[:end_date])
        if gon.block_end_time.nil? || gon.block_end_time.blank?
          gon.block_end_time = ''
        else
          gon.block_end_time = get_max_end_time(gon.block_end_time[0])
        end
        data = {
          :block_end_time => gon.block_end_time,
        }

        render :json => data
        # If the page just refreshed, use todays values to check for times to be blocked
      else
        date_now = DateTime.now
        date_s = date_now.day.to_s + " " + Date::MONTHNAMES[date_now.month] + " " + date_now.year.to_s
        gon.block_start_time = get_block_times(bookings, date_s)
        gon.block_end_time = get_block_times(bookings, date_s)

        if !gon.block_end_time[0].nil? || !gon.block_end_time[0].blank?
          gon.block_end_time = get_max_end_time(gon.block_end_time[0])
          if check_before_today(DateTime.new(date_now.year, date_now.month, date_now.day, gon.block_end_time[0].to_i, gon.block_end_time[1].to_i))
            gon.block_end_time = ''
          end
        else
          gon.block_end_time = ''
        end
      end
    end
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

# Convert the datetime object to an array, ie. Date time object with date 22/4/2018 ~> [2018,3,22]
def get_array_from_date(date_time)
  block_date = date_time.strftime("%Y-%m-%d").split('-')
  block_date[1] = (block_date[1].to_i - 1).to_s
  return block_date
end

# Convert the array of splitted date to a DateTime object, ie. [2018,3,22] ~> Date time object with date 22/4/2018
def get_date_from_array(array)
  return DateTime.new(array[0].to_i, array[1].to_i + 1, array[2].to_i, 0, 0, 0)
end

# Convert a date string into a DateTime object, ie. "22 March 2018" ~>  Date time object with date 22/3/2018
def get_date_from_string(s)
  return DateTime.parse(s + " 00:00:00")
end

# Check if the provided date time is before the date of today
def check_before_today(datetime)
  now = DateTime.now
  if DateTime.parse(datetime.to_time.to_s) < DateTime.new(now.year, now.month, now.day, 0, 0, 0)
    return true
  end
  return false
end

# Check if the provided date time is at the start of the day, ie 12AM
def check_start_of_day(datetime)
  if DateTime.parse(datetime.to_time.to_s) == DateTime.new(datetime.year, datetime.month, datetime.day, 0, 0, 0)
    return true
  end
  return false
end

# A loop to get the earliest date from the array from the start of today
def get_min_date(full_dates, today)
  dates = []

  # Get all the dates from the start of today
  full_dates.each do |d|
    if get_date_from_array(d) >= today
      dates.append(d)
    end
  end

  # If all dates are before today, return nothing to block
  if dates.nil? || dates.blank?
    max_end_date = []
    return max_end_date
  end

  # Get the set of dates with the lowest amount in years
  min_year_array = [dates[0]]
  max_end_date = dates[0]
  dates.each do |date|
    if date[0] == max_end_date[0]
      min_year_array.push(date)
    elsif date[0] < max_end_date[0]
      min_year_array = [date]
      max_end_date = date
    end
  end

  # Get the set of dates with the lowest amount in months
  min_month_array = [min_year_array[0]]
  max_end_date = min_month_array[0]
  min_year_array.each do |date|
    if date[1] == max_end_date[1]
      min_month_array.push(date)
    else
      min_month_array = [date]
      max_end_date = date
    end
  end

  # Get the single date with the lowest amount in days
  max_end_date = min_month_array[0]
  min_month_array.each do |date|
    if date[2] < max_end_date[2]
      max_end_date = date
    end
  end

  temp_date = get_date_from_array(max_end_date) - 1

  return get_array_from_date(temp_date)
end

def get_max_end_time(max_end_time)
  if max_end_time[1] != "00"
    max_end_time[1] = (max_end_time[1].to_i - 10).to_s
  else
    max_end_time[0] = (max_end_time[0].to_i - 1).to_s
    max_end_time[1] = "50"
  end
  return max_end_time
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

    # A loop to add the time strings to be blocked from the start to end time, does not add 5 PM to the blocked time
    while (temp_start_time.to_time - temp_end_time.to_time).to_i < 0
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

# Get block dates for single bookings
def get_single_block_dates(bookings)
  block_dates = []
  check_dates = []
  bookings.each do |booking|
    # If a single booking fills in the entire day
    if (booking.start_date).eql? booking.end_date
      if check_start_of_day(booking.start_time)
        block_dates.append(get_array_from_date(booking.start_datetime))
      end
      # If a single booking that spans 2 days, would fill up either day
      # elsif (booking.end_date - booking.start_date).to_i == 1
      #   if check_start_of_day(booking.start_time)
      #     block_dates.append(get_array_from_date(booking.start_datetime))
      #   end
      # If a booking that spans multiple days, it fills up the days in between, and checks if it fills up the start and end date
    elsif (booking.end_date - booking.start_date).to_i > 1
      ((Date.parse(booking.start_datetime.to_s) + 1)..(Date.parse(booking.end_datetime.to_s) - 1)).each do |date|
        block_dates.append(get_array_from_date(date))
      end
    end

    check_dates.append(booking.start_datetime)
    check_dates.append(booking.end_datetime)
  end

  check_dates.sort!

  return [block_dates, check_dates]
end

# Get the block dates for consecutive bookings
def get_cons_block_dates(check_dates, block_dates)
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
    # if !prev_day
      # CHECK IF BROKEN

      # if check_start_of_day(check_dates[i])
      #   block_dates.append(get_array_from_date(check_dates[i]))
      # end
    # else
    if prev_day
      # If it is connected, then block dates in between start and end
      ((Date.parse(check_dates[i].to_time.to_s) + 1)..(Date.parse(check_dates[end_count].to_s) - 1)).each do |date|
        block_dates.append(get_array_from_date(date))
      end
      # Check whether start date needs to be blocked
      # if check_start_of_day(check_dates[i])
      #   block_dates.append(get_array_from_date(check_dates[i]))
      # end
    end

    i = end_count + 1
  end

  return block_dates
end
