require 'rails_helper'
require 'spec_helper'

describe 'Managing bookings', js: true do

  before :each do
    FactoryBot.create :camera_category
    FactoryBot.create :gopro
    visit '/items/1/bookings/new'
    expect(page).to have_content 'Create booking on GoPro Hero 5'
  end

  specify 'I can create a booking without time conflict' do
    test_booking_date_start = DateTime.tomorrow.change({hour: 9, min: 0})
    test_booking_date_end = test_booking_date_start + 1.days
    page.execute_script("$('#startDate').val('#{test_booking_date_start.strftime("%d %B %Y")}')")
    page.execute_script("$('#startTime').val('#{test_booking_date_start.strftime("%I:%M %p")}')")
    page.execute_script("$('#endDate').prop('disabled', false)")
    page.execute_script("$('#endTime').prop('disabled', false)")
    page.execute_script("$('#endDate').val('#{test_booking_date_end.strftime("%d %B %Y")}')")
    page.execute_script("$('#endTime').val('#{test_booking_date_end.strftime("%I:%M %p")}')")
    fill_in 'booking_next_location', with: 'pam liversidge building'
    fill_in 'booking_reason', with: 'Filming documentary'
    click_button('Confirm booking')
    expect(page).to have_content 'Booking was successfully created'
    expect(page).to have_content 'My Bookings'
    expect(page).to have_content 'Pam Liversidge Building'
    expect(page).to have_content 'Filming documentary'
    expect(page).to have_content 'Accepted'
  end
end
