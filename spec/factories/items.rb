# == Schema Information
#
# Table name: items
#
#  id               :integer          not null, primary key
#  name             :string
#  condition        :string
#  location         :string
#  manufacturer     :string
#  model            :string
#  serial           :string
#  acquisition_date :date
#  purchase_price   :decimal(, )
#  image            :string
#  keywords         :string
#  po_number        :string
#  condition_info   :string
#  has_peripheral   :boolean
#  comment          :string
#  retired_date     :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  category_id      :integer
#  items_id         :integer
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#  index_items_on_items_id     (items_id)
#  index_items_on_serial       (serial) UNIQUE
#  index_items_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (items_id => items.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :gopro, class: 'Item' do
    name 'GoPro Hero 5'
    serial 'GPH5'
    location 'Diamond'
    user_id {User.find(1).id}
    association :category, factory: :camera_category

    trait :item_belongs_to_existing_user do
      user {User.find(1)}
    end
  end

  factory :macbook_pro, class: 'Item' do
    name 'Macbook Pro 15-inch'
    serial 'MPTR212/A'
    location 'Western Bank Library'
    has_peripheral 1
    user_id {User.find(1).id}
    association :category, factory: :laptop_category

    trait :item_belongs_to_existing_user do
      user {User.find(1)}
    end
  end

  factory :charging_cable, class: 'Item' do
    name 'Charging Cable'
    serial 'CC322'
    location 'Diamond'
    has_peripheral 0
    items_id 1
    user_id {User.find(1).id}
    association :category, factory: :laptop_peripheral_category
  end

  factory :laptop_admin, class: 'Item' do
    name 'Macbook Pro 15-inch'
    serial 'MPTR212/A'
    location 'Western Bank Library'
    association :user, factory: :admin
    association :category, factory: :laptop_category
  end

  factory :laptop_admin_has_peripheral, class: 'Item' do
    name 'Macbook Pro 15-inch'
    serial 'MPTR212/A'
    location 'Western Bank Library'
    has_peripheral 1
    association :user, factory: :admin
    association :category, factory: :laptop_category
  end

  factory :charging_cable_admin, class: 'Item' do
    name 'Charging Cable'
    serial 'CC322'
    location 'Diamond'
    has_peripheral 0
    items_id 1
    association :user, factory: :admin
    association :category, factory: :laptop_peripheral_category
  end
end
