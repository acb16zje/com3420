# == Schema Information
#
# Table name: categories
#
#  id           :integer          not null, primary key
#  name         :string
#  tag          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  categoryicon :string
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#  index_categories_on_tag   (tag) UNIQUE
#

FactoryBot.define do
  factory :category do
    name "MyString"
    items ""
  end
end
