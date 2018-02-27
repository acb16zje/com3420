# == Schema Information
#
# Table name: booking_states
#
#  id            :integer          not null, primary key
#  process_state :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class BookingState < ApplicationRecord
	has_many :res_bookings
end
