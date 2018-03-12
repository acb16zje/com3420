# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :condition
      t.string :location
      t.string :hash_id
      t.string :manufacturer
      t.string :model
      t.string :serial
      t.date :acquisition_date
      t.decimal :purchase_price
      t.string :image
      t.string :keywords

      t.timestamps
    end
    add_reference :items, :user, foreign_key: true
    add_reference :items, :category, foreign_key: true
  end
end
