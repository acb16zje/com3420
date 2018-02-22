class RemoveCostFromAsset < ActiveRecord::Migration[5.1]
  def change
    remove_column :assets, :cost, :real
  end
end
