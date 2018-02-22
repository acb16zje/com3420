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
#  serial       :string
#  manufacturer :string
#  user_id      :integer
#
# Indexes
#
#  index_assets_on_user_id  (user_id)
#

class Asset < ApplicationRecord
	belongs_to :user
	has_many :bookings
end
