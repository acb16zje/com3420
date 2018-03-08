# == Schema Information
#
# Table name: bookings
#
#  id         :integer          not null, primary key
#  start_date :date
#  start_time :time
#  end_date   :date
#  end_time   :time
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer
#  user_id    :integer
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
end
