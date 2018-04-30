# == Schema Information
#
# Table name: bookings
#
#  id                  :integer          not null, primary key
#  start_date          :date
#  start_time          :time
#  end_date            :date
#  end_time            :time
#  start_datetime      :datetime
#  end_datetime        :datetime
#  reason              :string
#  next_location       :string
#  status              :integer
#  peripherals         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  item_id             :integer
#  combined_booking_id :integer
#  user_id             :integer
#
# Indexes
#
#  index_bookings_on_combined_booking_id  (combined_booking_id)
#  index_bookings_on_item_id              (item_id)
#  index_bookings_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (combined_booking_id => combined_bookings.id)
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :combined_booking_requested, class: "CombinedBooking" do
    status 1
    user_id 1
    owner_id 1
  end

  factory :combined_booking_accepted, class: "CombinedBooking" do
    status 2
    user_id 1
    owner_id 1
  end

  factory :combined_booking_accepted_other, class: "CombinedBooking" do
    status 2
    user_id 2
    owner_id 1
  end

  factory :combined_booking_ongoing, class: "CombinedBooking" do
    status 3
    user_id 1
    owner_id 1
  end

  factory :combined_booking_late, class: "CombinedBooking" do
    status 7
    user_id 1
    owner_id 1
  end

  factory :booking_today_all_day, class: "Booking" do
    combined_booking_id 1
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    reason "Reason 1"
    next_location "Diamond"
    status 2
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

  factory :booking_to_reject, class: "Booking" do
    combined_booking_id 1
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 1

    association :user, factory: :user
    association :item, factory: :gopro
  end

  factory :booking_to_reject_2, class: "Booking" do
    combined_booking_id 1
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 1

    association :user, factory: :user
    association :item, factory: :charging_cable
  end

  factory :accepted_to_ongoing_booking, class: "Booking" do
    combined_booking_id 1
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 2
    user_id 1

    association :item, factory: :gopro
  end

  factory :accepted_to_ongoing_booking_2, class: "Booking" do
    combined_booking_id 1
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 2
    user_id 1

    association :item, factory: :charging_cable
  end

  factory :ongoing_booking, class: "Booking" do
    combined_booking_id 1
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

  factory :ongoing_booking_2, class: "Booking" do
    combined_booking_id 1
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 3
    user_id 1

    association :item, factory: :charging_cable
  end

  factory :ongoing_booking_other, class: "Booking" do
    combined_booking_id 1
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 3
    user_id 1

    association :item, factory: :laptop_admin
  end

  factory :due_booking_other, class: 'Booking' do
    combined_booking_id 1
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.tomorrow.strftime("%d %B %Y")}
    end_time {DateTime.tomorrow.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 3

    association :user, factory: :user
    association :item, factory: :gopro
  end

  factory :overdue_booking_other, class: 'Booking' do
    combined_booking_id 1
    start_date {DateTime.now.strftime("%d %B %Y")}
    start_time {DateTime.now.strftime("%H:%M")}
    start_datetime {DateTime.now}

    end_date {DateTime.now.strftime("%d %B %Y")}
    end_time {DateTime.now.change({hour:23, min: 50, sec:0}).strftime("%H:%M")}
    end_datetime {DateTime.now.change({hour:23, min: 50, sec:0})}

    next_location "Diamond"
    status 7

    association :user, factory: :user
    association :item, factory: :gopro
  end

  factory :single_booking_multiple_day_12am, class: 'Booking' do
    combined_booking_id 1
    start_date {Date.today - 1}
    start_time {"2000-01-01 00:00:00 UTC"}
    start_datetime {(Date.today - 1).to_s + ' ' + "00:00"}

    end_date {Date.tomorrow + 5}
    end_time {"13:00"}
    end_datetime {(Date.tomorrow + 5).to_s + ' ' + "13:00"}

    next_location "Diamond"
    status 2
    user_id 1

    association :item, factory: :gopro
  end

  factory :single_booking_multiple_day, class: 'Booking' do
    combined_booking_id 1
    start_date {Date.tomorrow}
    start_time {"2000-01-01 00:37:00 UTC"}
    start_datetime {Date.tomorrow.to_s + ' ' + "00:37"}

    end_date {Date.tomorrow + 5}
    end_time {"13:00"}
    end_datetime {(Date.tomorrow + 5).to_s + ' ' + "13:00"}

    next_location "Diamond"
    status 2
    user_id 1

    association :item, factory: :gopro
  end

  factory :fully_booked_days_multi_12am, class: 'Booking' do
    combined_booking_id 1
    start_date {Date.tomorrow}
    start_time {"2000-01-01 00:00:00 UTC"}
    start_datetime {Date.tomorrow.to_s + ' ' + "00:00"}

    end_date {Date.tomorrow}
    end_time {"13:00"}
    end_datetime {(Date.tomorrow).to_s + ' ' + "13:00"}

    next_location "Diamond"
    status 2
    user_id 1

    association :item, factory: :gopro
  end

  factory :fully_booked_days_multi_1, class: 'Booking' do
    combined_booking_id 2
    start_date {Date.tomorrow}
    start_time {"2000-01-01 13:00:00 UTC"}
    start_datetime {Date.tomorrow.to_s + ' ' + "13:00"}

    end_date {Date.tomorrow + 2}
    end_time {"12:00"}
    end_datetime {(Date.tomorrow + 2).to_s + ' ' + "12:00"}

    next_location "Diamond"
    status 2
    user_id 1
    item_id 1
  end

  factory :fully_booked_days_multi_2, class: 'Booking' do
    combined_booking_id 1
    start_date {Date.tomorrow}
    start_time {"2000-01-01 13:00:00 UTC"}
    start_datetime {Date.tomorrow.to_s + ' ' + "13:00"}

    end_date {Date.tomorrow}
    end_time {"20:00"}
    end_datetime {(Date.tomorrow).to_s + ' ' + "20:00"}

    next_location "Diamond"
    status 2
    user_id 1

    association :item, factory: :gopro
  end

  factory :fully_booked_days_multi_3, class: 'Booking' do
    combined_booking_id 2
    start_date {Date.tomorrow}
    start_time {"2000-01-01 20:00:00 UTC"}
    start_datetime {Date.tomorrow.to_s + ' ' + "20:00"}

    end_date {Date.tomorrow + 2}
    end_time {"01:00"}
    end_datetime {(Date.tomorrow + 2).to_s + ' ' + "01:00"}

    next_location "Diamond"
    status 2
    user_id 1
    item_id 1
  end

  factory :disable_start_time, class: 'Booking' do
    combined_booking_id 1
    start_date {Date.tomorrow}
    start_time {"2000-01-01 13:00:00 UTC"}
    start_datetime {Date.tomorrow.to_s + ' ' + "13:00"}

    end_date {Date.tomorrow + 2}
    end_time {"20:00"}
    end_datetime {(Date.tomorrow + 2).to_s + ' ' + "20:00"}

    next_location "Diamond"
    status 2
    user_id 1

    association :item, factory: :gopro

    trait :start_as_start_and_start_equal_end do
      end_date {Date.tomorrow}
      end_time {"20:00"}
      end_datetime {(Date.tomorrow).to_s + ' ' + "20:00"}
    end

    trait :start_as_end do
      start_date {Date.today - 2}
      start_time {"2000-01-01 00:00:00 UTC"}
      start_datetime {(Date.today - 2).to_s + ' ' + "00:00"}

      end_date {Date.tomorrow}
      end_time {"20:00"}
      end_datetime {(Date.tomorrow).to_s + ' ' + "20:00"}
    end
  end

  factory :max_end_time, class: 'Booking' do
    combined_booking_id 1
    start_date {Date.tomorrow}
    start_time {"2000-01-01 13:00:00 UTC"}
    start_datetime {Date.tomorrow.to_s + ' ' + "13:00"}

    end_date {Date.tomorrow + 2}
    end_time {"20:00"}
    end_datetime {(Date.tomorrow + 2).to_s + ' ' + "20:00"}

    next_location "Diamond"
    status 2
    user_id 1

    association :item, factory: :gopro

    trait :start_equal_end do
      start_date {Date.tomorrow + 2}
      start_time {"2000-01-01 20:00:00 UTC"}
      start_datetime {(Date.tomorrow + 2).to_s + ' ' + "20:00"}
    end
  end
end
