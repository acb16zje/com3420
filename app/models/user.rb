# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  forename               :string
#  surname                :string
#  password               :string
#  phone                  :string
#  department             :string
#  permission_id          :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  username               :string
#  uid                    :string
#  mail                   :string
#  ou                     :string
#  dn                     :string
#  sn                     :string
#  givenname              :string
#  category_id            :integer
#
# Indexes
#
#  index_users_on_category_id           (category_id)
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#

class User < ApplicationRecord

  include EpiCas::DeviseHelper
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :permission
	has_many :res_bookings
end
