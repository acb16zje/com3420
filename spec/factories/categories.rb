# == Schema Information
#
# Table name: categories
#
#  id           :integer          not null, primary key
#  name         :string
#  tag          :string
#  categoryicon :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#  index_categories_on_tag   (tag) UNIQUE
#

FactoryBot.define do
  factory :category, class: 'Category' do
    name "Laptops"
    tag "LPT"
  end
end
