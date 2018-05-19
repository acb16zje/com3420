# == Schema Information
#
# Table name: item_peripherals
#
#  id                 :integer          not null, primary key
#  parent_item_id     :integer
#  peripheral_item_id :integer
#
# Indexes
#
#  index_item_peripherals_on_parent_item_id                         (parent_item_id)
#  index_item_peripherals_on_parent_item_id_and_peripheral_item_id  (parent_item_id,peripheral_item_id) UNIQUE
#  index_item_peripherals_on_peripheral_item_id                     (peripheral_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_item_id => items.id)
#  fk_rails_...  (peripheral_item_id => items.id)
#

require 'rails_helper'

RSpec.describe ItemPeripheral, type: :model do
  describe 'Associations' do
    it {should belong_to :parent_item}
    it {should belong_to :peripheral_item}
  end

  describe 'Insert into database' do
    it 'check for valid field values in the database' do
      item_peripheral = ItemPeripheral.new(parent_item_id: 1, peripheral_item_id: 2)
      expect(item_peripheral.parent_item_id).to eq 1.to_i
      expect(item_peripheral.peripheral_item_id).to eq 2.to_i
    end
  end
end
