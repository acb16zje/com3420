# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  forename       :string
#  surname        :string
#  email          :string
#  password       :string
#  phone          :string
#  department     :string
#  permission_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  permissions_id :integer
#
# Indexes
#
#  index_users_on_permissions_id  (permissions_id)
#

class User < ApplicationRecord
	belongs_to :permission
	has_many :res_bookings
end
