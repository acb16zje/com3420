# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string
#  tag            :string
#  icon           :string
#  has_peripheral :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#  index_categories_on_tag   (tag) UNIQUE
#

FactoryBot.define do
  factory :laptop_category, class: 'Category' do
    name "Laptops"
  end

  factory :camera_category, class: 'Category' do
    name "Cameras"
  end
end
