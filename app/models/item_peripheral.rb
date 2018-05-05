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
#  index_item_peripherals_on_parent_item_id      (parent_item_id)
#  index_item_peripherals_on_peripheral_item_id  (peripheral_item_id)
#

class ItemPeripheral < ApplicationRecord
    belongs_to :parent_item, :class_name => 'Item'
    belongs_to :peripheral_item, :class_name => 'Item'
end