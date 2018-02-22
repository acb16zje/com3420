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
#  user_id      :integer
#  asset_id     :integer
#
# Indexes
#
#  index_bookings_on_asset_id  (asset_id)
#  index_bookings_on_user_id   (user_id)
#

require 'rails_helper'

RSpec.describe Booking, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
