# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string
#  tag            :string
#  icon           :string
#  has_peripheral :boolean
#  is_peripheral  :boolean
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
    name 'Lagtops'
    tag 'LAP'
  end

  factory :camera_category, class: 'Category' do
    name 'Cameras'
    tag 'CAM'
  end
end
