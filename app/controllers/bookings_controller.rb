require 'irb'

class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]
  authorize_resource

  # Booking status {1: Pending, 2: Accepted, 3: Ongoing, 4: Completed,
  # 5: Rejected, 6: Cancelled, 7: Late}

  # GET /bookings
  def index
    # @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ?", current_user.id)
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

  # GET /bookings/new
  def new
    @booking = Booking.new
    @item = Item.find_by_id(params[:item_id])
    bookings = Booking.where("bookings.status = 2 or bookings.status = 3")
    block_dates = []
    check_dates = []
    # check_start_dates = []
    # check_end_dates = []

    bookings.each do |booking|
      # If a single booking fills in the entire day
      if (booking.start_date).eql? booking.end_date
        if DateTime.parse(booking.start_time.to_time.to_s) <= (DateTime.new(2000, 1, 1, 9, 0, 0).to_time) &&
           DateTime.parse(booking.end_time.to_time.to_s) >= (DateTime.new(2000, 1, 1, 17, 0, 0).to_time)
          block_date = booking.start_datetime.strftime("%Y-%m-%d").split('-')
          block_date[1] = (block_date[1].to_i - 1).to_s
          block_dates.append(block_date)
        end
        # If a single booking that spans 2 days, would fill up either day
      elsif (booking.end_date - booking.start_date).to_i == 1
        if DateTime.parse(booking.start_time.to_time.to_s) <= (DateTime.new(2000, 1, 1, 9, 0, 0).to_time)
          block_date = booking.start_datetime.strftime("%Y-%m-%d").split('-')
          block_date[1] = (block_date[1].to_i - 1).to_s
          block_dates.append(block_date)
        end
        if DateTime.parse(booking.end_time.to_time.to_s) >= (DateTime.new(2000, 1, 1, 17, 0, 0).to_time)
          block_date = booking.end_datetime.strftime("%Y-%m-%d").split('-')
          block_date[1] = (block_date[1].to_i - 1).to_s
          block_dates.append(block_date)
        end
        # If a booking that spans multiple days, it fills up the days in between, and checks if it fills up the start and end date
      elsif (booking.end_date - booking.start_date).to_i > 1
        ((Date.parse(booking.start_datetime.to_s) + 1)..(Date.parse(booking.end_datetime.to_s) - 1)).each do |date|
          block_date = date.strftime("%Y-%m-%d").split('-')
          block_date[1] = (block_date[1].to_i - 1).to_s
          block_dates.append(block_date)
        end
        
        if DateTime.parse(booking.start_time.to_time.to_s) <= (DateTime.new(2000, 1, 1, 9, 0, 0).to_time)
          block_date = booking.start_datetime.strftime("%Y-%m-%d").split('-')
          block_date[1] = (block_date[1].to_i - 1).to_s
          block_dates.append(block_date)
        end
        
        if DateTime.parse(booking.end_time.to_time.to_s) >= (DateTime.new(2000, 1, 1, 17, 0, 0).to_time)
          block_date = booking.end_datetime.strftime("%Y-%m-%d").split('-')
          block_date[1] = (block_date[1].to_i - 1).to_s
          block_dates.append(block_date)
        end
      end
      
      check_dates.append(booking.start_datetime)
      check_dates.append(booking.end_datetime)
      # check_start_dates.append(booking.start_datetime)
      # check_end_dates.append(booking.end_datetime)
    end

    i = 0
    check_dates.sort!
    # check_start_dates.sort!
    # check_end_dates.sort!
    
    not_found_pair = false
    while i < check_dates.length - 2
      # so the start count will point to the correct day
      start_count = i + 1
      end_count = i + 1
      
      prev_day = false
      next_day = false
      start_index = 0
      end_index = 0
      
      # Checks for consecutive times and gets the the end of the streak
      while (check_dates[start_count].to_time - check_dates[end_count + 1].to_time).to_i == 0
        start_count += 2
        end_count += 2
        break if check_dates[end_count + 1].nil?
      end
      
      # Checks if the first time of the section is connected to a booking on the previous day
      if (Date.parse(check_dates[end_count].to_time.to_s)- Date.parse(check_dates[i].to_time.to_s)) > 0
        prev_day = true
        start_count -= 1
        # start_index = check_end_dates.index(check_dates[i])
      else
        # start_index = check_start_dates.index(check_dates[i])
      end
      
      # # Checks if the last time of the section is connected to a  booking on the next day
      # if (check_start_dates.include? check_dates.last)
      #   next_day = true
      #   end_count += 1
      #   end_index = check_start_dates.index(check_dates[i])
      # else
      #   end_index = check_end_dates.index(check_dates[i])
      # end
      
      puts
      puts
      puts "startcount"
      puts check_dates[i]
      puts "endcount"
      puts check_dates[end_count]
      puts prev_day
      puts
      puts

      # If it is not connected to the previous day, then check whether the start time and end time of the consecutive bookings fills the day
      if !prev_day
        if DateTime.parse(check_dates[i].to_time.to_s) <= (DateTime.new(check_dates[i].year, check_dates[i].month, check_dates[i].day, 9, 0, 0))
          if DateTime.parse(check_dates[end_count].to_time.to_s) >= (DateTime.new(check_dates[end_count].year, check_dates[end_count].month, check_dates[end_count].day, 17, 0, 0))
            block_date = check_dates[i].strftime("%Y-%m-%d").split('-')
            block_date[1] = (block_date[1].to_i - 1).to_s
            block_dates.append(block_date)
          end
        end
      else
        ((Date.parse(check_dates[i].to_s) + 1)..(Date.parse(check_dates[end_count].to_s) - 1)).each do |date|
          block_date = date.strftime("%Y-%m-%d").split('-')
          block_date[1] = (block_date[1].to_i - 1).to_s
          block_dates.append(block_date)
        end
        
        if DateTime.parse(check_dates[i].to_s) <= (DateTime.new(check_dates[i].year, check_dates[i].month, check_dates[i].day, 9, 0, 0))
          block_date = check_dates[i].strftime("%Y-%m-%d").split('-')
          puts "hiasdasdas"
          block_date[1] = (block_date[1].to_i - 1).to_s
          block_dates.append(block_date)
        end

        if DateTime.parse(check_dates[end_count].to_s) >= (DateTime.new(check_dates[end_count].year, check_dates[end_count].month, check_dates[end_count].day, 17, 0, 0))
          block_date = check_dates[end_count].strftime("%Y-%m-%d").split('-')
          block_date[1] = (block_date[1].to_i - 1).to_s
          block_dates.append(block_date)
        end
      end

      # i +=1
      i = end_count + 1
    end

    gon.block_dates = block_dates
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
      UserMailer.user_booking_requested(User.find(@booking.user_id), Item.find(@booking.item_id)).deliver
      UserMailer.manager_booking_requested(User.find(@booking.user_id), Item.find(@booking.item_id), User.find((Item.find(@booking.item_id)).user_id)).deliver
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
        UserMailer.booking_approved(User.find(@booking.user_id), Item.find(@booking.item_id)).deliver
      elsif @booking.status == 5
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

  #
  def set_booking_cancelled
    @booking = Booking.find(params[:id])
    @booking.status = 6
    if @booking.save
      redirect_to bookings_path, notice: 'Booking was successfully cancelled.'
    else
      redirect_to bookings_path, notice: 'Could not cancel booking.'
    end
  end

  #
  def set_booking_returned
    @booking = Booking.find(params[:id])
    @booking.status = 4
    if @booking.save
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
