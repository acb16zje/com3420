# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  forename   :string
#  surname    :string
#  email      :string
#  password   :string
#  phone      :string
#  department :string
#  permission :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
