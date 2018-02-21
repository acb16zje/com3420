class AddManufacturerToAsset < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :location, :string
    add_column :assets, :cost, :real
    add_column :assets, :serial, :string
    add_column :assets, :manufacturer, :string
  end
end
