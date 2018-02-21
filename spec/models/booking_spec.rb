# == Schema Information
#
# Table name: bookings
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  serial       :string
#  manufacturer :string
#  start        :datetime
#  end          :datetime
#  state        :string
#

require 'rails_helper'

RSpec.describe Booking, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
