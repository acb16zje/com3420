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
#  user_id      :integer
#
# Indexes
#
#  index_assets_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :asset do
    
  end
end
