# == Schema Information
#
# Table name: bookings
#
#  id                  :integer          not null, primary key
#  start_date          :date
#  start_time          :time
#  end_date            :date
#  end_time            :time
#  start_datetime      :datetime
#  end_datetime        :datetime
#  reason              :string
#  next_location       :string
#  status              :integer
#  peripherals         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  item_id             :integer
#  combined_booking_id :integer
#  user_id             :integer
#
# Indexes
#
#  index_bookings_on_combined_booking_id  (combined_booking_id)
#  index_bookings_on_item_id              (item_id)
#  index_bookings_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (combined_booking_id => combined_bookings.id)
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe "Validations" do
    it "is not valid without a user" do
      uhc = FactoryBot.create :user_home_category
      uhc.user = nil
      expect(uhc).to_not be_valid
    end

    it "is not valid without a category" do
      uhc = FactoryBot.create :user_home_category
      uhc.user = nil
      expect(uhc).to_not be_valid
    end
  end

  describe 'Insert into database' do
    it 'check for valid field values in the database' do
      booking = Booking.new(
        start_date: '2018-04-28', start_time: '01:00:00', end_date: '2018-04-29', end_time: '03:00:00',
        start_datetime: '2018-04-28 01:00:00', end_datetime: '2018-04-29 03:00:00', reason: 'None', next_location: 'Diamond',
        status: 1, peripherals: [""])
      expect(booking.start_datetime).to eq '2018-04-28 01:00:00'
      expect(booking.end_datetime).to eq '2018-04-29 03:00:00'
      expect(booking.reason).to eq 'None'
      expect(booking.next_location).to eq 'Diamond'
    end
  end
end
