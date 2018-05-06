# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  recipient_id    :integer
#  context         :string
#  read_at         :datetime
#  action          :string
#  notifiable_id   :integer
#  notifiable_type :string
#

require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Associations' do
    it {should belong_to(:recipient)}
    it {should belong_to(:notifiable)}
  end

  describe 'Scope' do
    it 'check for unread' do
      Notification.unread.should eq Notification.where(read_at: nil)
    end
  end

  describe 'Insert into database' do
    it 'check for valid field values in the database' do
      notification = Notification.new(recipient_id: 1, action: 'rejected', context: 'U')
      expect(notification.recipient_id).to eq 1
      expect(notification.action).to eq 'rejected'
      expect(notification.context).to eq 'U'
      expect(notification.read_at).to eq nil
    end
  end
end
