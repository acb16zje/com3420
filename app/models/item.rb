# == Schema Information
#
# Table name: items
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  name             :string
#  condition        :string
#  location         :string
#  manufacturer     :string
#  model            :string
#  serial           :string
#  acquisition_date :date
#  purchase_price   :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  category_id      :integer
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#  index_items_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#

class Item < ApplicationRecord
  belongs_to :category
  has_many :bookings

end
