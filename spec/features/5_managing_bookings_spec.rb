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
    page.execute_script("$('#startDate').val('#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').val('#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').prop('disabled', false)")
    page.execute_script("$('#endTime').prop('disabled', false)")
    page.execute_script("$('#endDate').val('#{test_booking_date_end.strftime("%d %B %Y")}')")
    page.execute_script("$('#endTime').val('#{test_booking_date_end.strftime("%I:%M %p")}')")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    click_button('Confirm booking')
    expect(page).to have_content 'Booking was successfully created'
    expect(page).to have_content 'My Bookings'
    expect(page).to have_content 'Pam Liversidge Building'
    expect(page).to have_content 'Accepted'
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
    expect(page).to have_css("#bookings", :text => "No data")
  end

  specify "I can see bookings made by me" do
    FactoryBot.create(:booking_today_all_day, :booking_and_item_belongs_to_same_user)
    visit '/bookings'
    expect(page).to have_css("#bookings", :text => "1 GoPro")
  end

  specify 'I can cancel my booking' do
    FactoryBot.create(:booking_today_all_day, :booking_and_item_belongs_to_same_user)
    visit '/bookings'
    click_link 'Cancel Booking'
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
end
