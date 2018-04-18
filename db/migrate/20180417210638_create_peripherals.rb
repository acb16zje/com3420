class CreatePeripherals < ActiveRecord::Migration[5.1]
  def change
    create_table :peripherals do |t|
      t.references :parent_item
      t.references :peripheral_item

      t.timestamps
    end
  end
end
