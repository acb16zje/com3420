class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.string :reason

      t.timestamps
    end
    add_reference :bookings, :item, foreign_key: true
    add_reference :bookings, :user, foreign_key: true
  end
end
