# == Schema Information
#
# Table name: booking_states
#
#  id            :integer          not null, primary key
#  process_state :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :booking_state do
    process_state "MyString"
  end
end
