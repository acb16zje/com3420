class BookingStateRefToResBooking < ActiveRecord::Migration[5.1]
  def change
  	add_reference :res_bookings, :booking_states, foreign_key: true
  end
end
