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

FactoryGirl.define do
  factory :booking do
    
  end
end
