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
#  comment          :string
#  retired_date     :date
#  peripheral_only  :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  category_id      :integer
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

class Item < ApplicationRecord
  belongs_to :category

  has_many :parent_items, :class_name => 'Peripheral', :foreign_key => 'parent_item_id'
  has_many :peripheral_items, :class_name => 'Peripheral', :foreign_key => 'peripheral_item_id'

  has_many :booking_items, class_name: "BookingItem", foreign_key: "item_id"
  has_many :bookings, through: :booking_items

  belongs_to :user
  mount_uploader :image, ImageUploader

  attr_accessor :create_peripherals

  def getItemPeripherals
    peripherals_for_item = Peripheral.where(parent_item: self)
    peripherals_for_item.map(&:peripheral_item)
  end
end
