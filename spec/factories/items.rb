# == Schema Information
#
# Table name: items
#
#  id                  :integer          not null, primary key
#  name                :string
#  condition           :string
#  location            :string
#  manufacturer        :string
#  model               :string
#  serial              :string
#  acquisition_date    :date
#  purchase_price      :decimal(, )
#  image               :string
#  keywords            :string
#  parent_asset_serial :string
#  po_number           :string
#  condition_info      :string
#  has_peripheral      :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer
#  category_id         :integer
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#  index_items_on_serial       (serial) UNIQUE
#  index_items_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
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

  factory :laptop_item, class: 'Item' do
    name 'Macbook Pro 15-inch'
    serial 'MPTR212/A'
    location 'Western Bank Library'
    user_id {User.find(1).id}
    association :category, factory: :laptop_category

    trait :item_belongs_to_existing_user do
      user {User.find(1)}
    end
  end

  factory :laptop_erica, class: 'Item' do
    name 'Macbook Pro 15-inch'
    serial 'MPTR212/A'
    location 'Western Bank Library'
    association :user, factory: :erica
    association :category, factory: :laptop_category
  end
end
