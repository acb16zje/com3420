class AddSerialToBooking < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :serial, :string
  end
end
