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

FactoryGirl.define do
  factory :user do
    forename "MyString"
    surname "MyString"
    email "MyString"
    password "MyString"
    phone "MyString"
    department "MyString"
    permission "MyString"
  end
end
