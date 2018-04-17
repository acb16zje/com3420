require 'rails_helper'
require 'spec_helper'

describe 'Managing bookings', js: true do
  specify 'Viewing all booking status pages' do
    visit 'bookings/requests'
    visit 'bookings/accepted'
    FactoryBot.create(:booking_today_all_day_mine)
    visit 'bookings/ongoing'
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
    page.execute_script("$('#endDate').prop('disabled', false)")
    page.execute_script("$('#endTime').prop('disabled', false)")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}')")
    page.execute_script("$('#endTime').pickatime('picker').set('select', '#{test_booking_date_end.strftime("%I:%M %p")}')")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    click_button('Confirm booking')
    expect(page).to have_content 'Booking was successfully created'
    expect(page).to have_content 'My Bookings'
    expect(page).to have_content 'Pam Liversidge Building'
    expect(page).to have_content 'Pending'
  end

  # specify 'I can create a booking without time conflict, item owned by other with peripherals' do
  #   FactoryBot.create(:laptop_admin)
  #   FactoryBot.create(:charging_cable_admin)
  #   visit '/items/1/bookings/new'
  #   test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
  #   test_booking_date_end = test_booking_date_start + 1.days
  #   page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
  #   page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}')")
  #   page.execute_script("$('#endDate').prop('disabled', false)")
  #   page.execute_script("$('#endTime').prop('disabled', false)")
  #   page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}')")
  #   page.execute_script("$('#endTime').pickatime('picker').set('select', '#{test_booking_date_end.strftime("%I:%M %p")}')")
  #   fill_in 'booking_next_location', with: 'pam liversidge building'
  #   click_button('Confirm booking')
  #   expect(page).to have_content 'Booking was successfully created'
  #   expect(page).to have_content 'My Bookings'
  #   expect(page).to have_content 'Pam Liversidge Building'
  #   expect(page).to have_content 'Pending'
  # end

  specify 'I can create a booking with peripherals without time conflict' do
    FactoryBot.create(:macbook_pro)
    FactoryBot.create(:charging_cable)
    visit '/items/1/bookings/new'
    test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}');")
    page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}');")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}');")
    page.execute_script("$('#endTime').pickatime('picker').set('select', '#{test_booking_date_end.strftime("%I:%M %p")}');")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    page.execute_script("$('#peripherals').prop('disabled', false);")
    select('CC322', from: 'peripherals')
    click_button('Confirm booking')
    expect(page).to have_content 'Accepted'
  end

  specify 'I can edit booking of a peripheral' do
    FactoryBot.create(:macbook_pro)
    FactoryBot.create(:charging_cable)
    visit '/items/2/bookings/new'
    test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').pickadate('picker').set('select', '#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').pickatime('picker').set('select', '#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').pickadate('picker').set('select', '#{test_booking_date_end.strftime("%d %B %Y")}')")
    page.execute_script("$('#endTime').pickatime('picker').set('select', '#{test_booking_date_end.strftime("%I:%M %p")}')")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    click_button('Confirm booking')
    visit '/bookings/1/edit'
    click_button 'Save changes'
  end

  specify 'I can edit my booking' do
    FactoryBot.create(:booking_today_all_day_mine)
    visit '/bookings'
    click_link 'Edit'
    fill_in 'booking_next_location', with: 'nothing'
    click_button 'Save changes'
  end

  specify "I cannot see bookings made for other users" do
    FactoryBot.create(:booking_today_all_day)
    visit '/bookings'
    expect(page).to have_content 'No data'
  end

  specify "I can see bookings made by me" do
    FactoryBot.create(:booking_today_all_day, :booking_and_item_belongs_to_same_user)
    visit '/bookings'
    expect(page).to have_content '1 GoPro'
  end

  specify 'I can cancel my booking' do
    FactoryBot.create(:booking_today_all_day, :booking_and_item_belongs_to_same_user)
    visit '/bookings'
    click_link 'Cancel Booking'
  end

  specify 'I can reject a booking' do
    FactoryBot.create(:booking_today_all_day_not_mine)
    visit '/bookings/requests'
    click_button 'Reject'
  end

  specify 'I can return my item as like new' do
    FactoryBot.create(:ongoing_booking)
    visit '/bookings'
    click_link 'Return Item'
    click_button('Save changes')
  end

  specify 'I can return my item as damaged' do
    FactoryBot.create(:ongoing_booking)
    visit '/bookings'
    click_link 'Return Item'
    select('Damaged', from: 'item_condition')
    click_button('Save changes')
    find(:css, ".notifications-bell").hover
  end

  specify 'I can return item owned by other' do
    FactoryBot.create(:ongoing_booking_other)
    visit '/bookings'
    click_link 'Return Item'
    click_button('Save changes')
  end

  specify 'I can return item owned by other as damaged' do
    FactoryBot.create(:ongoing_booking_other)
    visit '/bookings'
    click_link 'Return Item'
    select('Damaged', from: 'item_condition')
    click_button('Save changes')
  end

  specify 'single booking multiple day 12am' do
    FactoryBot.create(:single_booking_multiple_day_12am)
    visit '/items/1/bookings/new'
  end

  specify 'single booking multiple day' do
    FactoryBot.create(:single_booking_multiple_day)
    visit '/items/1/bookings/new'
  end
end
