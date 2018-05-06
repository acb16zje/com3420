# == Schema Information
#
# Table name: items
#
#  id               :integer          not null, primary key
#  name             :string
#  condition        :string
#  location         :string
#  manufacturer     :string
#  model            :string
#  serial           :string
#  acquisition_date :date
#  purchase_price   :decimal(, )
#  image            :string
#  keywords         :string
#  po_number        :string
#  condition_info   :string
#  comment          :string
#  retired_date     :date
#  user_id          :integer
#  category_id      :integer
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#  index_items_on_serial       (serial) UNIQUE
#  index_items_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Associations' do
    it {should belong_to :category}
    it {should belong_to :user}
    it {should have_many :bookings}
  end

  describe 'Methods' do
    it 'check for get item peripherals' do
      item = Item.new(name: 'Macbook Pro', condition: 'Like New', location: 'Diamond',
                      user_id: 1, category_id: 1)
      item.get_item_peripherals
    end

    it 'check for get item parents' do
      item = Item.new(name: 'Macbook Pro', condition: 'Like New', location: 'Diamond',
                      user_id: 1, category_id: 1)
      item.get_item_parents
    end
  end

  describe 'Insert into database' do
    it 'check for valid field values in the database' do
      item = Item.new(name: 'Macbook Pro', condition: 'Like New', location: 'Diamond',
                      user_id: 1, category_id: 1)
      expect(item.name).to eq 'Macbook Pro'
      expect(item.condition).to eq 'Like New'
      expect(item.location).to eq 'Diamond'
      expect(item.user_id).to eq 1.to_i
      expect(item.category_id).to eq 1.to_i
    end
  end
end
