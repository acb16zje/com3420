# == Schema Information
#
# Table name: booking_states
#
#  id            :integer          not null, primary key
#  process_state :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe BookingState, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
