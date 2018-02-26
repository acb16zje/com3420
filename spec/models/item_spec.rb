# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  category     :string
#  condition    :string
#  name         :string
#  location     :string
#  peripherals  :string
#  image        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  manufacturer :string
#

require 'rails_helper'

RSpec.describe Item, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
