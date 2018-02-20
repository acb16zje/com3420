class AddCategoryToAsset < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :category, :string
  end
end
