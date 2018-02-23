# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  category    :string
#  condition   :string
#  name        :string
#  location    :string
#  peripherals :string
#  image       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Item < ApplicationRecord
end