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

  describe 'Insert into database' do
    it 'check for valid field values in the database' do
      combined_booking = CombinedBooking.new(id: 1, status: 2, owner_id: 2, user_id: 2)
      expect(combined_booking.id).to eq 1.to_i
      expect(combined_booking.status).to eq 2.to_i
      expect(combined_booking.owner_id).to eq 2.to_i
      expect(combined_booking.user_id).to eq 2.to_i
    end
  end
end
