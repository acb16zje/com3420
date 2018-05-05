class CreateItemPeripheral < ActiveRecord::Migration[5.1]
  def change
    create_table :item_peripherals do |t|
      t.references :parent_item
      t.references :peripheral_item
    end

    # add_foreign_key :item_peripherals, :items, column: :parent_id, primary_key: :id
    # add_foreign_key :item_peripherals, :items, column: :peripheral_id, primary_key: :id
  end
end
