# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]
  # authorize_resource

  # GET /bookings
  def index
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ?", current_user.id)
  end

  # GET /bookings/1
  def show
  end

  # GET /bookings/requests
  def requests
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and bookings.status = 1", current_user.id)
  end

  # GET /bookings/requests
  def accepted
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and bookings.status = 2", current_user.id)
  end

  # GET /bookings/requests
  def ongoing
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and bookings.status = 3", current_user.id)
  end

  # GET /bookings/requests
  def completed
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and bookings.status = 4", current_user.id)
  end

  # GET /bookings/requests
  def rejected
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id and items.user_id = ? and bookings.status = 5", current_user.id)
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @item = Item.find_by_id(params[:item_id])
  end

  # GET /bookings/1/edit
  def edit; end

  # POST /bookings
  def create
    @booking = Booking.new(booking_params)

    # Booking status {1: Pending, 2: Accepted, 3: Ongoing, 4: Completed, 5: Rejected}
    @booking.status = 1

    if @booking.save
      redirect_to bookings_path, notice: 'Booking was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bookings/1
  def update
    if @booking.update(booking_params)
      redirect_to bookings_path, notice: 'Booking was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: 'Booking was successfully destroyed.'
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
