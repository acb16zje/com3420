class AddIndexToCategories < ActiveRecord::Migration[5.1]
  def change
    add_index :categories, :name, unique: true
    add_index :categories, :tag, unique: true
  end
end
