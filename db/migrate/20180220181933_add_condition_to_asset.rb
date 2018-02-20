class AddConditionToAsset < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :condition, :string
  end
end
