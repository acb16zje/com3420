# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  condition       :string
#  name            :string
#  location        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  manufacturer    :string
#  category_id     :integer
#  serial          :string
#  model           :string
#  aquisition_date :date
#  purchase_price  :decimal(, )
#  user_id         :integer
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#  index_items_on_user_id      (user_id)
#

FactoryGirl.define do
  factory :item do
    category "MyString"
    condition "MyString"
    name "MyString"
    location "MyString"
    peripherals "MyString"
    image "MyString"
  end
end
