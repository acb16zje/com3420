class AddItemRefToResBooking < ActiveRecord::Migration[5.1]
  def change
    add_reference :res_bookings, :items, foreign_key: true
  end
end
