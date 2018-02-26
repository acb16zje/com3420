class ResBookingAddedColumnState < ActiveRecord::Migration[5.1]
  def change
  	add_column :res_bookings, :state_id, :integer
  end
end
