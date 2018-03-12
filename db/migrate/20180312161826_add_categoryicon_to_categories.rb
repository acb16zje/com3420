class AddCategoryiconToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :categoryicon, :string
  end
end
