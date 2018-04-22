require 'rails_helper'
require 'spec_helper'

describe 'Managing error pages' do
  specify 'Viewing all error pages' do
    visit '/403'
    expect(page).to have_content('403 Access Denied')

    visit '/404'
    expect(page).to have_content('404 Page Not Found')

    visit '/422'
    expect(page).to have_content('422 Change Rejected')

    visit '/500'
    expect(page).to have_content('500 Internal Server Error')

    visit '/javascript_warning'
    expect(page).to have_content('JavaScript Required')
  end

  specify 'When visiting a link that does not exist' do
    visit '/items/pagedoesnotexist'
    expect(page).to have_content('404 Page Not Found')
  end

end