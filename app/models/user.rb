# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  phone              :string
#  permission_id      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  email              :string           default(""), not null
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :inet
#  last_sign_in_ip    :inet
#  username           :string
#  uid                :string
#  mail               :string
#  ou                 :string
#  dn                 :string
#  sn                 :string
#  givenname          :string
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username)
#

class User < ApplicationRecord
  include EpiCas::DeviseHelper

  def generate_attributes_from_ldap_info
    self.username = uid
    self.email = mail
    super # This needs to be left in so the default fields are also set
  end

  def return_full_name
    "#{self.givenname} #{self.sn}"
  end

  has_many :bookings
  has_many :items
  has_many :categories, through: :user_home_categories
  has_many :notifications, foreign_key: :recipient_id
end
