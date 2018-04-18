# == Schema Information
#
# Table name: bookings
#
#  id             :integer          not null, primary key
#  start_date     :date
#  start_time     :time
#  end_date       :date
#  end_time       :time
#  start_datetime :datetime
#  end_datetime   :datetime
#  reason         :string
#  next_location  :string
#  status         :integer
#  peripherals    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :integer
#  user_id        :integer
#
# Indexes
#
#  index_bookings_on_item_id  (item_id)
#  index_bookings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (user_id => users.id)
#

class Booking < ApplicationRecord
  belongs_to :item
  belongs_to :user
  has_many :booking_items, class_name: "BookingItem", foreign_key: "booking_id", dependent: :destroy
end
