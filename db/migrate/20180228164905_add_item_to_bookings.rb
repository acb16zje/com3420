class AddItemToBookings < ActiveRecord::Migration[5.1]
  def change
    add_reference :bookings, :item, foreign_key: true
  end
end
