# == Schema Information
#
# Table name: bookings
#
#  id         :integer          not null, primary key
#  start_date :date
#  start_time :time
#  end_date   :date
#  end_time   :time
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer
#
# Indexes
#
#  index_bookings_on_item_id  (item_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#

FactoryBot.define do
  factory :booking do
    # start_date "2018-02-28 16:47:37"
    # end_date "2018-02-28 16:47:37"
    # reason "MyString"
  end
end
