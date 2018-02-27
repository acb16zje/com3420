class RemoveCategoryFromItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :category
    remove_column :items, :peripherals
    remove_column :items, :image
  end
end
