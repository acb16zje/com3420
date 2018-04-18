class CreateBookingItems < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_items do |t|
      t.references :item, foreign_key: true
      t.references :booking, foreign_key: true

      t.timestamps
    end
  end
end
