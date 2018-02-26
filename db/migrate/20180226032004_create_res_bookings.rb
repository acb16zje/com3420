class CreateResBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :res_bookings do |t|
      t.integer :item_id
      t.string :user_email
      t.integer :manager_id
      t.datetime :out_date
      t.datetime :in_date
      t.text :comments

      t.timestamps
    end
  end
end
