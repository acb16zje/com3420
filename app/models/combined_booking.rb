# == Schema Information
#
# Table name: combined_bookings
#
#  id       :integer          not null, primary key
#  status   :integer
#  owner_id :integer
#  user_id  :integer
#
# Indexes
#
#  index_combined_bookings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class CombinedBooking < ApplicationRecord
  belongs_to :user
  has_many :bookings

  def sorted_bookings
    managers = bookings.map { |b| b.item.user }.uniq
    booking_list = managers.map { |m| Booking.joins(:item).where('items.user_id = ? AND combined_booking_id = ?', m.id, id) }
  end
end
