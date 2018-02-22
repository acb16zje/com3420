class AddAssetRefToBookings < ActiveRecord::Migration[5.1]
  def change
    add_reference :bookings, :asset, foreign_key: true
  end
end
