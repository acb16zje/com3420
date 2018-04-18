class Peripheral < ApplicationRecord
  belongs_to :parent_item, :class_name => 'Item'
  belongs_to :peripheral_item, :class_name => 'Item'
end
