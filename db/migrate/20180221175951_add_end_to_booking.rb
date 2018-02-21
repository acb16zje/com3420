class AddEndToBooking < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :end, :datetime
  end
end
