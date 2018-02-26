# == Schema Information
#
# Table name: res_bookings
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  user_email :string
#  manager_id :integer
#  out_date   :datetime
#  in_date    :datetime
#  comments   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :res_booking do
    item_id 1
    user_email "MyString"
    manager_id 1
    out_date "2018-02-26 04:20:05"
    in_date "2018-02-26 04:20:05"
    comments "MyText"
  end
end
