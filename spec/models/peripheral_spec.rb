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

require 'rails_helper'

RSpec.describe Peripheral, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
