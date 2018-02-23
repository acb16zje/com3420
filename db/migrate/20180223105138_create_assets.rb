class CreateAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :assets do |t|
      t.string :category
      t.string :condition
      t.string :name
      t.string :location
      t.string :peripherals
      t.string :image

      t.timestamps
    end
  end
end
