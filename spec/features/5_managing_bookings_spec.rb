require 'rails_helper'
require 'spec_helper'

describe 'Managing bookings', js: true do
  before :each do
    FactoryBot.create :category
    FactoryBot.create :item
    visit '/items/1/bookings/new'
    expect(page).to have_content 'Create booking on GoPro Hero 5'
  end

  specify 'I can create a booking without time conflict' do
    page.execute_script("$('#startDate').val('2 April 2018')")
    page.execute_script("$('#startTime').val('9:00 AM')")
    page.execute_script("$('#endDate').prop('disabled', false)")
    page.execute_script("$('#endTime').prop('disabled', false)")
    page.execute_script("$('#endDate').val('3 April 2018')")
    page.execute_script("$('#endTime').val('12:30 PM')")
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
