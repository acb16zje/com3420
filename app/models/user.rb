# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  forename      :string
#  surname       :string
#  password      :string
#  phone         :string
#  department    :string
#  permission_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class User < ApplicationRecord

  include EpiCas::DeviseHelper
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :permission

	#-has_many :res_bookings
end
