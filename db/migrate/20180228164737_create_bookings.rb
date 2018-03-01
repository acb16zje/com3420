class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.datetime :start
      t.datetime :end
      t.string :reason

      t.timestamps
    end
    add_reference :bookings, :item, foreign_key: true
  end
end
