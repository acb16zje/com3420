require 'irb'

class CombinedBookingsController < ApplicationController
  load_and_authorize_resource

  # Set booking as accepted
  def set_booking_accepted
    @bookings = Booking.where(combined_booking_id: params[:id])
    @bookings.each do |booking|
      next if booking.status != 1
      booking.status = 2
      if booking.save
        Notification.create(recipient: booking.user, action: 'accepted', notifiable: booking, context: 'AM')
      end
    end

    combined_booking = CombinedBooking.find(params[:id])
    combined_booking.status = 2
    if combined_booking.save
      UserMailer.booking_approved(combined_booking.bookings)
      redirect_to requests_bookings_path, notice: 'Remaining bookings were successfully accepted.'
    end
  end

  # Set booking as rejected
  def set_booking_rejected
    @bookings = Booking.where(combined_booking_id: params[:id])
    @bookings.each do |booking|
      next if booking.status != 1
      booking.status = 5
      if booking.save
        Notification.create(recipient: booking.user, action: 'rejected', notifiable: booking, context: 'AM')
      end
    end

    combined_booking = CombinedBooking.find(params[:id])
    combined_booking.status = 5
    if combined_booking.save
      UserMailer.booking_rejected(combined_booking.bookings).deliver
      redirect_to requests_bookings_path, notice: 'Remaining bookings were successfully rejected.'
    end
  end

  # Set booking as cancelled
  def set_booking_cancelled
    @bookings = Booking.where(combined_booking_id: params[:id])
    @bookings.each do |booking|
      booking.status = 6
      if booking.save
        Notification.create(recipient: booking.user, action: 'cancelled', notifiable: booking, context: 'AM')
      end
    end

    combined_booking = CombinedBooking.find(params[:id])
    combined_booking.status = 6
    if combined_booking.save
      combined_booking.sorted_bookings.each do |m|
        UserMailer.manager_booking_cancelled(m).deliver
      end
      redirect_to bookings_path, notice: 'Remaining bookings were successfully cancelled.'
    end
  end

  # PUT /bookings/1/set_booking_returned
  def set_booking_returned
    bookings = Booking.where(combined_booking_id: params[:id])

    bookings.each do |booking|
      next if booking.status != 3
      booking.status = 4
      if booking.save
        Notification.create(recipient: booking.user, action: 'returned', notifiable: booking, context: 'AM')
      end
    end

    combined_booking = CombinedBooking.find(params[:id])
    combined_booking.status = 4
    if combined_booking.save
      combined_booking.sorted_bookings.each do |m|
        UserMailer.manager_asset_returned(m).deliver
      end
      redirect_to bookings_path, notice: 'Remaining assets were successfully returned.'
    end
  end
end
