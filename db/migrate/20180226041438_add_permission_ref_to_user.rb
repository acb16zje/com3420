class AddPermissionRefToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :permissions, foreign_key: true
  end
end
