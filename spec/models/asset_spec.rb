# == Schema Information
#
# Table name: assets
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  asset_name   :string
#  category     :string
#  owner        :string
#  condition    :string
#  location     :string
#  cost         :real
#  serial       :string
#  manufacturer :string
#

require 'rails_helper'

RSpec.describe Asset, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
