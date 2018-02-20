class AddOwnerToAsset < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :owner, :string
  end
end
