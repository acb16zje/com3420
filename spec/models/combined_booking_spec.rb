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

require 'rails_helper'

RSpec.describe CombinedBooking, type: :model do
  describe 'Associations' do
    it { should belong_to :user }
    it { should have_many :bookings }
  end

  describe 'Methods' do
    it 'check for sorted bookings' do
      combined_booking = CombinedBooking.new(id: 1, status: 2, owner_id: 2, user_id: 2)
      combined_booking.sorted_bookings
    end
  end

  # describe 'Insert into database' do
  #   it 'check for valid field values in the database' do
  #     booking = Booking.new(
  #         start_date: '2018-04-28', start_time: '01:00:00', end_date: '2018-04-29', end_time: '03:00:00',
  #         start_datetime: '2018-04-28 01:00:00', end_datetime: '2018-04-29 03:00:00', reason: 'None', next_location: 'Diamond',
  #         status: 1, peripherals: ['']
  #     )
  #     expect(booking.start_datetime).to eq '2018-04-28 01:00:00'
  #     expect(booking.end_datetime).to eq '2018-04-29 03:00:00'
  #     expect(booking.reason).to eq 'None'
  #     expect(booking.next_location).to eq 'Diamond'
  #   end
  # end
end
