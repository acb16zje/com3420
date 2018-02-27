# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.integer 'user_id'
      t.string :name
      t.string :condition
      t.string :location
      # t.string :peripherals
      # t.string :image
      t.string :manufacturer
      t.string :model
      t.string :serial
      t.string :acquisition_date
      t.string :purchase_price
      t.index ['user_id'], name: 'index_items_on_user_id'

      t.timestamps
    end
  end
end
