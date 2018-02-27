class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :forename
      t.string :surname
      t.string :email
      t.string :password
      t.string :phone
      t.string :department
      t.integer :permission_id

      t.timestamps
    end
  end
end
