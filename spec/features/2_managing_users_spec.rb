require 'rails_helper'
require 'spec_helper'

describe 'Managing accounts' do
  before :each do
    click_link('Sign Out')
    @username = sign_in_details(true)
  end

  specify 'I can create an account with a MUSE email with user permission' do
    create_weikin_user
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk User'
  end

  specify 'I can create an account with a MUSE email with asset manager permission' do
    create_weikin_asset_manager
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk Asset Manager'
  end

  specify 'I can create an account with a MUSE email with admin permission' do
    create_weikin_admin
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk Admin'
  end

  specify 'I cannot create an account with a non valid MUSE email' do
    create_invalid_email
    expect(page).to have_content 'Not a valid email.'
    visit '/users'
    expect(page).to_not have_content 'notvalid@sheffield.ac.uk Admin'
  end

  specify 'I cannot create an account that already exists' do
    create_weikin_user
    create_weikin_admin
    expect(page).to have_content 'Account already exists.'
  end

  specify 'I can view a list of users that exist in the database' do
    create_weikin_admin
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk Admin'
  end

  specify 'I can view the details of a user' do
    create_weikin_admin
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk Admin'
    click_link('view_user_aca16wkk')
    expect(page).to have_content 'aca16wkk'
  end

  specify 'I can edit my profile details' do
    visit '/users'
    view_link = page.find("#view_user_#{@username}", visible: :all)
    view_link.click
    expect(page).to have_content 'Edit Details'
    click_link('Edit Details')
    details_title = page.find('#DetailsTitle', visible: :all)
    fill_in 'number', with: '05050505050'
    click_button('Save changes')
    expect(page).to have_content 'User was successfully updated'
    expect(page).to have_content '05050505050'
  end

  specify 'I can delete a different user' do
    create_weikin_admin
    visit '/users'
    click_link('view_user_aca16wkk')
    expect(page).to have_content 'aca16wkk'
    click_link('Edit Details')
    expect(page).to have_content 'Delete'
    click_link('Delete')
    expect(page).to have_content 'User was successfully deleted.'
    expect(page).to_not have_content 'wkkhaw1@sheffield.ac.uk Admin'
  end

  specify 'I cannot delete my own account' do
    visit '/users'
    view_link = page.find("#view_user_#{@username}", visible: :all)
    view_link.click
    expect(page).to have_content 'Edit Details'
    click_link('Edit Details')
    expect(page).to_not have_content 'Delete'
  end

  specify 'I can view the list of asset managers' do
    create_weikin_admin
    click_link 'Asset Managers'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk'
  end

  specify 'I can change the permission of my account to asset manager' do
    click_link('My Profile')
    expect(page).to have_content 'Edit Details'
    click_link('Edit Details')
    select('Asset Manager', from: 'user_permission_id')
    click_button('Save changes')
  end

  specify 'I can change the permission of my account to user' do
    click_link('My Profile')
    expect(page).to have_content 'Edit Details'
    click_link('Edit Details')
    select('User', from: 'user_permission_id')
    click_button('Save changes')
    visit '/categories'
    expect(page).to have_content '403'
  end
end
