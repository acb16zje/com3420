class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.string :reason
      t.string :next_location
      t.integer :status

      t.timestamps
    end
    add_reference :bookings, :item, foreign_key: true
    add_reference :bookings, :user, foreign_key: true
  end
end
