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
  pending "add some examples to (or delete) #{__FILE__}"
end
