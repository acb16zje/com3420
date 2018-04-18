# == Schema Information
#
# Table name: peripherals
#
#  id                 :integer          not null, primary key
#  parent_item_id     :integer
#  peripheral_item_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_peripherals_on_parent_item_id      (parent_item_id)
#  index_peripherals_on_peripheral_item_id  (peripheral_item_id)
#

class Peripheral < ApplicationRecord
  belongs_to :parent_item, :class_name => 'Item'
  belongs_to :peripheral_item, :class_name => 'Item'
end
