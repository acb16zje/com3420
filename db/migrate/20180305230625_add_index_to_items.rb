class AddIndexToItems < ActiveRecord::Migration[5.1]
  def change
    add_index :items, :hash_id, :unique => true
  end
end
