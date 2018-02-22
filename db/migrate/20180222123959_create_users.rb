class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :forename
      t.string :surname
      t.string :email
      t.string :password
      t.string :phone
      t.string :department
      t.string :permission

      t.timestamps
    end
  end
end
