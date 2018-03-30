class AddIndexToItems < ActiveRecord::Migration[5.1]
  def change
    add_index :items, :serial, :unique => true
  end
end
