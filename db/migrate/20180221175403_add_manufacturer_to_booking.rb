class AddManufacturerToBooking < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :manufacturer, :string
  end
end
