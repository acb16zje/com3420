class AddPlaceOfWorkToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :placeofwork, :string
  end
end
