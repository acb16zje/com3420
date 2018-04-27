class CreateCombinedBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :combined_bookings do |t|
      t.integer :status
    end

    add_reference :combined_bookings, :user, foreign_key: true
  end
end
