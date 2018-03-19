# == Schema Information
#
# Table name: items
#
#  id               :integer          not null, primary key
#  name             :string
#  condition        :string
#  location         :string
#  serial_id        :string
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
#  index_items_on_category_id  (category_id)
#  index_items_on_serial_id    (serial_id) UNIQUE
#  index_items_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

class Item < ApplicationRecord
  belongs_to :category
  has_many :bookings
  belongs_to :user
  mount_uploader :image, ImageUploader
end
