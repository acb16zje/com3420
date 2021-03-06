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

FactoryBot.define do
  factory :macbook_pro_charging_cable, class: 'ItemPeripheral' do
    association :parent_item, factory: :macbook_pro
    association :peripheral_item, factory: :charging_cable
  end

  factory :macbook_pro_admin_charging_cable, class: 'ItemPeripheral' do
    association :parent_item, factory: :laptop_admin
    association :peripheral_item, factory: :charging_cable_admin
  end
end
