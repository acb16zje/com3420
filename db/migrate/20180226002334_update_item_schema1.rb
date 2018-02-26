class UpdateItemSchema1 < ActiveRecord::Migration[5.1]
  def change
  	add_column :items, :manufacturer, :string
  end
end
