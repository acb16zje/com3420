class AddConditionInfoToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :condition_info, :string
  end
end
