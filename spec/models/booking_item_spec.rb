# == Schema Information
#
# Table name: booking_items
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  booking_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_booking_items_on_booking_id  (booking_id)
#  index_booking_items_on_item_id     (item_id)
#
# Foreign Keys
#
#  fk_rails_...  (booking_id => bookings.id)
#  fk_rails_...  (item_id => items.id)
#

require 'rails_helper'

RSpec.describe BookingItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
