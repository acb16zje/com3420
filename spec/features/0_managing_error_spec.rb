require 'rails_helper'
require 'spec_helper'

describe 'Managing error pages' do
  specify 'Viewing all error pages' do
    visit '/403'
    expect(page).to have_content('403 Access Denied')

    visit '/403'
    expect(page).to have_content('403 Access Denied')

    visit '/404'
    expect(page).to have_content('404 Page not found')

    visit '/422'
    expect(page).to have_content('422 Change Rejected')

    visit '/500'
    expect(page).to have_content('500 Internal Server Error')
  end
end