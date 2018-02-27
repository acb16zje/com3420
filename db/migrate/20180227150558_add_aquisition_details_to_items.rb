class AddAquisitionDetailsToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :aquisition_date, :date
    add_column :items, :purchase_price, :decimal
  end
end
