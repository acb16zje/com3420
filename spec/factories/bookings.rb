# == Schema Information
#
# Table name: bookings
#
#  id             :integer          not null, primary key
#  start_date     :date
#  start_time     :time
#  end_date       :date
#  end_time       :time
#  start_datetime :datetime
#  end_datetime   :datetime
#  reason         :string
#  next_location  :string
#  status         :integer
#  peripherals    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :integer
#  user_id        :integer
#
# Indexes
#
#  index_bookings_on_item_id  (item_id)
#  index_bookings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do

  factory :booking_today_all_day, class: "Booking" do
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    reason "Reason 1"
    next_location "Diamond"
    status "None"
    peripherals ""

    association :user, factory: :user
    association :item, factory: :gopro

    trait :booking_belongs_to_existing_user do
      user {User.find(1)}
    end

    trait :booking_and_item_belongs_to_same_user do
      user {User.find(1)}
      association :item, factory: :gopro do
        item_belongs_to_existing_user
      end
    end
  end

  factory :booking_today_all_day_mine, class: "Booking" do
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 2
    peripherals ""
    user_id 1

    association :item, factory: :gopro
  end

  factory :ongoing_booking, class: "Booking" do
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 3
    user_id 1

    association :item, factory: :gopro
  end

  factory :ongoing_booking_other, class: "Booking" do
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 3
    user_id 1

    association :item, factory: :gopro
  end
end
