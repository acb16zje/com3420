class AddSerialAndModelToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :serial, :string
    add_column :items, :model, :string
  end
end
