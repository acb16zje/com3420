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

FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:email) {|n| "exampleuser#{n}@sheffield.ac.uk"}
    givenname 'Example'
    sn 'User'
    permission_id 1
    sequence(:username) {|n| "std#{n}usr"}
  end

  factory :assetmanager, class: 'User' do
    sequence(:email) {|n| "examplemanager#{n}@sheffield.ac.uk"}
    givenname 'Example'
    sn 'Manager'
    permission_id 2
    sequence(:username) {|n| "ama#{n}usr"}
  end

  factory :admin, class: 'User' do
    sequence(:email) {|n| "exampleadmin#{n}@sheffield.ac.uk"}
    givenname 'Example'
    sn 'Admin'
    permission_id 3
    sequence(:username) {|n| "adm#{n}usr"}
  end
end
