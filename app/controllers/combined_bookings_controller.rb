require 'irb'

class CombinedBookingsController < ApplicationController
  # before_action :set_user, only: %i[show edit update destroy]
  # authorize_resource

  # Set booking as cancelled
  def set_booking_cancelled
    @bookings = Booking.where(combined_booking_id: params[:id])
    @bookings.each do |booking|
      puts booking.id
      booking.status = 6
      if booking.save
        Notification.create(recipient: booking.user, action: 'cancelled', notifiable: booking, context: 'AM')
        UserMailer.manager_booking_cancelled(booking).deliver
      end
    end
    combined_booking = CombinedBooking.find(params[:id])
    combined_booking.status = 6
    if combined_booking.save
      redirect_to bookings_path, notice: 'Booking was successfully cancelled.'
    end
  end

  # GET /bookings/1/booking_returned
  def booking_returned
    @booking = Booking.find_by_id(params[:id])
    @bookings = Booking.where(combined_booking_id: params[:id])
    @booking_nums = @bookings.length
    @item = @bookings.first.item
  end

  # PUT /bookings/1/set_booking_returned
  def set_booking_returned
    bookings = Booking.where(combined_booking_id: params[:id])
    
    bookings.each do |booking|
      next if booking.status != 3
      booking.status = 4
      if booking.save
        Notification.create(recipient: booking.user, action: 'returned', notifiable: booking, context: 'AM')
        UserMailer.manager_asset_returned(booking).deliver
      end
    end
    combined_booking = CombinedBooking.find(params[:id])
    combined_booking.status = 4
    if combined_booking.save
      redirect_to bookings_path, notice: 'Remaining items were returned'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).except(:bunny).permit!
  end
end
