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
#  cost         :float
#  serial       :string
#  manufacturer :string
#

FactoryGirl.define do
  factory :asset do
    
  end
end
