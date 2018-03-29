# == Schema Information
#
# Table name: items
#
#  id               :integer          not null, primary key
#  name             :string
#  condition        :string
#  location         :string
#  asset_tag        :string
#  manufacturer     :string
#  model            :string
#  serial           :string
#  acquisition_date :date
#  purchase_price   :decimal(, )
#  image            :string
#  keywords         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  category_id      :integer
#
# Indexes
#
#  index_items_on_asset_tag    (asset_tag) UNIQUE
#  index_items_on_category_id  (category_id)
#  index_items_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :item, class: 'Item' do
    user_id 1
    category_id '1'
    condition 'Like New'
    name'GoPro Hero 5'
    location 'Diamond'
    asset_tag 'CAM00001'
    manufacturer 'GoPro'
    model 'Hero 5'
    serial 'GPH5'
    acquisition_date '2018-03-09'
    purchase_price 100.1
  end
end
