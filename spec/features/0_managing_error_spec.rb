require 'rails_helper'
require 'spec_helper'

describe 'Managing error pages' do
  specify 'Viewing 403 pages' do
    visit '/403'
    expect(page).to have_content('403 Access Denied')
  end

  specify 'Viewing 404 pages' do
    visit '/404'
    expect(page).to have_content('404 Page not found')
  end

  specify 'Viewing 422 pages' do
    visit '/422'
    expect(page).to have_content('422 Change Rejected')
  end

  specify 'Viewing 500 pages' do
    visit '/500'
    expect(page).to have_content('500 Internal Server Error')
  end
end