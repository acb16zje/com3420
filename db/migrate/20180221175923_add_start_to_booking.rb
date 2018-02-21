class AddStartToBooking < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :start, :datetime
  end
end
