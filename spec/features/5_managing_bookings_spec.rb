require 'rails_helper'
require 'spec_helper'

describe 'Managing bookings', js: true do
  specify 'Viewing all booking status pages' do
    visit 'bookings/requests'
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:accepted_to_ongoing_booking)
    visit 'bookings/accepted'
    visit 'bookings/ongoing'
    bookings = Booking.where('status = 2 AND start_datetime <= ?', DateTime.now.strftime("%Y-%m-%d %H:%M:%S"))
    bookings.each do |b|
      Notification.create(recipient: b.user, action: "started", notifiable: b, context: "U")
      Notification.create(recipient: b.item.user, action: "started", notifiable: b, context: "AM")
      b.status = 3
      b.save
    end

    combined = bookings.map{|b| b.combined_booking}.uniq
    combined.each do |b|
      if b.status == 2
        b.status = 3
        if b.save
          UserMailer.booking_ongoing(b).deliver
        end
      end
    end

    visit 'bookings/completed'
    visit 'bookings/rejected'
    visit 'bookings/late'
  end

  specify 'I can create a booking without time conflict' do
    FactoryBot.create(:gopro)
    visit '/items/1/bookings/new'
    expect(page).to have_content 'Create booking on GoPro Hero 5'
    test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}')")
    page.execute_script("$('#endTime').pickatime('picker').set('select', '#{test_booking_date_end.strftime("%I:%M %p")}')")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    click_button('Confirm booking')
    expect(page).to have_content 'Booking was successfully created'
    expect(page).to have_content 'My Bookings'
    expect(page).to have_content 'Pam Liversidge Building'
    find(:css, ".details-control").click
    expect(page).to have_content 'Accepted'
  end

  specify 'I cannot create two booking on the same time' do
    FactoryBot.create(:gopro)
    visit '/items/1/bookings/new'
    expect(page).to have_content 'Create booking on GoPro Hero 5'
    test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}')")
    page.execute_script("$('#endTime').pickatime('picker').set('select', '#{test_booking_date_end.strftime("%I:%M %p")}')")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    click_button('Confirm booking')
    expect(page).to have_content 'Booking was successfully created'
    expect(page).to have_content 'My Bookings'
    expect(page).to have_content 'Pam Liversidge Building'
    find(:css, ".details-control").click
    expect(page).to have_content 'Accepted'

    visit '/items/1/bookings/new'
    expect(page).to have_content 'Create booking on GoPro Hero 5'
    test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').val('#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').prop('disabled', false)")
    page.execute_script("$('#startTime').val('#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').prop('disabled', false)")
    page.execute_script("$('#endTime').prop('disabled', false)")
    page.execute_script("$('#endDate').val('#{test_booking_date_end.strftime("%d %B %Y")}')")
    page.execute_script("$('#endTime').val('#{test_booking_date_end.strftime("%I:%M %p")}')")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    click_button('Confirm booking')
    expect(page).to have_content 'conflicts'
  end

  specify 'I can create a booking without time conflict, item owned by other' do
    FactoryBot.create(:laptop_admin)
    visit '/items/1/bookings/new'
    test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}')")
    page.execute_script("$('#endTime').pickatime('picker').set('select', '#{test_booking_date_end.strftime("%I:%M %p")}')")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    click_button('Confirm booking')
    expect(page).to have_content 'Booking was successfully created'
    expect(page).to have_content 'My Bookings'
    expect(page).to have_content 'Pam Liversidge Building'
    find(:css, ".details-control").click
    expect(page).to have_content 'Pending'
  end

  specify 'I can create a booking without time conflict, item owned by other with peripherals' do
    FactoryBot.create(:macbook_pro_admin_charging_cable)
    visit '/items/1/bookings/new'
    expect(page).to have_content 'MPTR212/A'
    test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}')")
    page.execute_script("$('#endTime').pickatime('picker').set('select', '#{test_booking_date_end.strftime("%I:%M %p")}')")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    select('CC322', from: 'peripherals')
    click_button('Confirm booking')
    expect(page).to have_content 'Booking was successfully created'
    expect(page).to have_content 'My Bookings'
    expect(page).to have_content 'Pam Liversidge Building'
    find(:css, ".details-control").click
    expect(page).to have_content 'Pending'
  end

  specify 'I can create a booking with peripherals without time conflict' do
    FactoryBot.create(:macbook_pro_charging_cable)
    visit '/items/1/bookings/new'
    test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}');")
    page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}');")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}');")
    page.execute_script("$('#endTime').pickatime('picker').set('select', '#{test_booking_date_end.strftime("%I:%M %p")}');")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    select('CC322', from: 'peripherals')
    click_button('Confirm booking')
    find(:css, ".details-control").click
    expect(page).to have_content 'Accepted'
  end

  specify 'I can edit booking of a peripheral' do
    FactoryBot.create(:macbook_pro_charging_cable)
    visit '/items/2/bookings/new'
    test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}')")
    page.execute_script("$('#endTime').pickatime('picker').set('select', '#{test_booking_date_end.strftime("%I:%M %p")}')")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    click_button 'Confirm booking'
    visit '/bookings/1/edit'
    click_button 'Save changes'
  end

  specify 'I can edit my booking' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:booking_today_all_day, :booking_and_item_belongs_to_same_user)
    visit '/bookings'
    find(:css, ".details-control").click
    click_link 'Edit'
    fill_in 'booking_next_location', with: 'nothing'
    click_button 'Save changes'
  end

  specify "I cannot see bookings made for other users" do
    FactoryBot.create(:user)
    FactoryBot.create(:combined_booking_accepted_other)
    FactoryBot.create(:booking_today_all_day)
    visit '/bookings'
    expect(page).to have_content 'No data'
  end

  specify "I can see bookings made by me" do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:booking_today_all_day, :booking_and_item_belongs_to_same_user)
    visit '/bookings'
    find(:css, ".details-control").click
    expect(page).to have_content 'GoPro'
  end

  specify 'I can cancel my booking' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:booking_today_all_day, :booking_and_item_belongs_to_same_user)
    visit '/bookings'
    find(:css, ".details-control").click
    click_link 'Cancel Booking'
    expect(page).to have_content 'cancelled'
  end

  specify 'I can reject a booking' do
    FactoryBot.create(:combined_booking_requested)
    FactoryBot.create(:booking_to_reject)
    visit '/bookings/requests'
    find(:css, ".details-control").click
    expect(page).to have_content 'Reject'
    find(:css, "#reject_single_booking1").click
    expect(page).to have_content 'No data'
  end

  specify 'I can reject a combined booking' do
    FactoryBot.create(:combined_booking_requested)
    FactoryBot.create(:booking_to_reject)
    FactoryBot.create(:booking_to_reject_2)
    visit '/bookings/requests'
    click_link 'Reject all'
    visit '/bookings/rejected'
    expect(page).to_not have_content 'No data'
  end

  specify 'I can accept a booking' do
    FactoryBot.create(:combined_booking_requested)
    FactoryBot.create(:booking_to_reject)
    visit '/bookings/requests'
    find(:css, ".details-control").click
    expect(page).to have_content 'Accept'
    find(:css, "#accept_single_booking1").click
    expect(page).to have_content 'No data'
  end

  specify 'I can accept a combined booking' do
    FactoryBot.create(:combined_booking_requested)
    FactoryBot.create(:booking_to_reject)
    FactoryBot.create(:booking_to_reject_2)
    visit '/bookings/requests'
    click_link 'Accept all'
    visit '/bookings/accepted'
    expect(page).to_not have_content 'No data'
  end

  specify 'I can return a combined booking' do
    FactoryBot.create(:combined_booking_ongoing)
    FactoryBot.create(:ongoing_booking)
    FactoryBot.create(:ongoing_booking_2)
    visit '/bookings'
    click_link 'Return all'
    visit '/bookings'
    expect(page).to_not have_content 'Return all'
  end

  specify 'I can cancel a combined booking' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:accepted_to_ongoing_booking)
    FactoryBot.create(:accepted_to_ongoing_booking_2)
    visit '/bookings/'
    click_link 'Cancel all'
    visit '/bookings/'
    expect(page).to_not have_content 'Cancel all'
  end

  specify 'I can return my item as like new as a user' do
    FactoryBot.create(:combined_booking_ongoing)
    FactoryBot.create(:ongoing_booking)
    visit '/bookings'
    find(:css, ".details-control").click
    click_link 'Return Item'
    click_button('Return Item')
  end

  specify 'I can return my item as damaged' do
    FactoryBot.create(:combined_booking_ongoing)
    FactoryBot.create(:ongoing_booking)
    visit '/bookings'
    find(:css, ".details-control").click
    click_link 'Return Item'
    select('Damaged', from: 'item_condition')
    click_button('Return Item')
    find(:css, ".notifications-bell").hover
  end

  specify 'I can return item owned by other' do
    FactoryBot.create(:combined_booking_ongoing)
    FactoryBot.create(:ongoing_booking_other)
    visit '/bookings'
    find(:css, ".details-control").click
    click_link 'Return Item'
    click_button('Return Item')
  end

  specify 'I can return item owned by other as damaged' do
    FactoryBot.create(:combined_booking_ongoing)
    FactoryBot.create(:ongoing_booking_other)
    visit '/bookings'
    find(:css, ".details-control").click
    click_link 'Return Item'
    select('Damaged', from: 'item_condition')
    click_button('Return Item')
  end

  specify 'Remind user that their booking ends soon' do
    FactoryBot.create(:combined_booking_ongoing)
    FactoryBot.create(:due_booking_other)

    # Get bookings ending soon
    bookings = Booking.where('status = 3 AND end_datetime < ?', (DateTime.now + 3.days).strftime("%Y-%m-%d %H:%M:%S"))
    # Get their parent bookings
    combined = bookings.map{|b| b.combined_booking}.uniq

    #Send for each booking
    combined.each do |b|
      UserMailer.asset_due(b).deliver
    end
  end

  specify 'Remind user of late booking return' do
    FactoryBot.create(:combined_booking_late)
    FactoryBot.create(:overdue_booking_other)

    bookings = Booking.where('status = 7')
    bookings.each do |b|
      Notification.create(recipient: b.user, action: "overdue", notifiable: b, context: "U")
      Notification.create(recipient: b.item.user, action: "overdue", notifiable: b, context: "AM")
    end
    # Get their parent bookings
    combined = bookings.map{|b| b.combined_booking}.uniq
    #Send for each booking
    combined.each do |b|
      UserMailer.asset_overdue(b).deliver
    end
  end

  # Ajax calls to controller testing
  specify 'single booking multiple day 12am' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:single_booking_multiple_day_12am)
    visit '/items/1/bookings/new'
  end

  specify 'single booking multiple day' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:single_booking_multiple_day)
    visit '/items/1/bookings/new'
  end

  specify 'fully booked days multi 12am' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:fully_booked_days_multi_12am)
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:fully_booked_days_multi_1)
    visit '/items/1/bookings/new'
  end

  specify 'fully booked days multi' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:fully_booked_days_multi_2)
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:fully_booked_days_multi_3)
    visit '/items/1/bookings/new'
  end

  specify 'disable start time, selected start date is booked as start date, booking start date != end date' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:disable_start_time)
    visit '/items/1/bookings/new'
    test_booking_date_start = DateTime.tomorrow
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
  end

  specify 'disable start time, selected start date is booked as start date, booking start date = end date' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:disable_start_time, :start_as_start_and_start_equal_end)
    visit '/items/1/bookings/new'
    test_booking_date_start = DateTime.tomorrow
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
  end

  specify 'disable start time, selected start date is booked as end date' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:disable_start_time, :start_as_end)
    visit '/items/1/bookings/new'
    test_booking_date_start = DateTime.tomorrow.change({hour: 10, min: 0})
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
  end

  specify 'max end time, start date < end date' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:max_end_time)
    visit '/items/1/bookings/new'
    test_booking_date_start = DateTime.tomorrow.change({hour: 10, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}')")
  end

  specify 'max end time, start date = end date' do
    FactoryBot.create(:combined_booking_accepted)
    FactoryBot.create(:max_end_time, :start_equal_end)
    visit '/items/1/bookings/new'
    test_booking_date_start = DateTime.tomorrow.change({hour: 10, min: 0})
    test_booking_date_end = DateTime.tomorrow.change({hour: 19, min: 0})
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}')")
  end
end
