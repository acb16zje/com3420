# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string
#  icon           :string
#  has_peripheral :boolean
#  is_peripheral  :boolean
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#

FactoryBot.define do
  factory :laptop_category, class: 'Category' do
    name 'Laptops'
    has_peripheral 1
    is_peripheral 0
  end

  factory :laptop_peripheral_category, class: 'Category' do
    name 'Laptops - Peripherals'
    has_peripheral 0
    is_peripheral 1
  end

  factory :camera_category, class: 'Category' do
    name 'Cameras'
    has_peripheral 1
    is_peripheral 0
  end

  factory :camera_peripheral_category, class: 'Category' do
    name 'Cameras - Peripherals'
    has_peripheral 0
    is_peripheral 1
  end

  factory :data_logger_category, class: 'Category' do
    name 'Data Logger'
    has_peripheral 0
    is_peripheral 0
  end
end
