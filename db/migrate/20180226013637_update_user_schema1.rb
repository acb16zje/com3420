class UpdateUserSchema1 < ActiveRecord::Migration[5.1]
  def change
  	change_column :users, :permission, :integer
  	rename_column :users, :permission, :permission_id
  end
end
