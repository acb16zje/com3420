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

class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where read_at: nil }
end
