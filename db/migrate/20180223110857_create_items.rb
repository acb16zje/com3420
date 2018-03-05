# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.integer 'user_id'
      t.string :name
      t.string :condition
      t.string :location
      t.string :hash_id
      t.string :manufacturer
      t.string :model
      t.string :serial
      t.date :acquisition_date
      t.decimal :purchase_price
      t.index ['user_id'], name: 'index_items_on_user_id'

      t.timestamps
    end
    add_reference :items, :category, foreign_key: true
  end
end
