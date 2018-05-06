# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  phone              :string
#  permission_id      :integer
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

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it {should have_many(:combined_bookings)}
    it {should have_many(:bookings)}
    it {should have_many(:items)}
    it {should have_many(:user_home_categories)}
    it {should have_many(:categories).through(:user_home_categories)}
    it {should have_many(:notifications)}
  end

  describe 'Methods' do
    it 'generate ldap info' do
      user = User.new(email: 'zjeng1@sheffield.ac.uk', givenname: 'Zer Jun', sn: 'Eng')
      user.generate_attributes_from_ldap_info
    end
  end

  describe 'Insert into database' do
    it 'check for valid field values in the database' do
      user = User.new(email: 'zjeng1@sheffield.ac.uk', givenname: 'Zer Jun', sn: 'Eng')
      expect(user.email).to eq 'zjeng1@sheffield.ac.uk'
      expect(user.givenname).to eq 'Zer Jun'
      expect(user.sn).to eq 'Eng'
    end
  end
end
