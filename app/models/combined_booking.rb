# == Schema Information
#
# Table name: combined_bookings
#
#  id      :integer          not null, primary key
#  status  :integer
#  user_id :integer
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
end