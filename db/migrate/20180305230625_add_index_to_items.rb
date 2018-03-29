class AddIndexToItems < ActiveRecord::Migration[5.1]
  def change
    add_index :items, :asset_tag, :unique => true
  end
end
