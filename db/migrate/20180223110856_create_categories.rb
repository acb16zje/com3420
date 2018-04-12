class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :icon
      t.boolean :has_peripheral
      t.boolean :is_peripheral

      t.timestamps
    end
  end
end
