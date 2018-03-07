require 'rails_helper'
require 'spec_helper'

describe 'Managing accounts' do
  before :each do
    visit '/users/new'
    expect(page).to have_content 'Create user'
  end

  specify 'I can create an account with a MUSE email with the user permission status' do
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('User', :from => 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'User was successfully created.'
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk User'
  end

  specify 'I can create an account with a MUSE email with the asset manager permission status' do
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('Asset Manager', :from => 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'User was successfully created.'
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk Asset Manager'
  end

  specify 'I can create an account with a MUSE email with the admin permission status' do
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('Admin', :from => 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'User was successfully created.'
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk Admin'
  end

  specify 'I cannot create an account with something that is not an email' do
    fill_in 'user_email', with: 'notvalid'
    select('Admin', :from => 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'Not a valid email.'
    visit '/users'
    expect(page).to_not have_content 'notvalid Admin'
  end

  specify 'I cannot create an account with a non valid MUSE email' do
    fill_in 'user_email', with: 'notvalid@sheffield.ac.uk'
    select('Admin', :from => 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'Not a valid email.'
    visit '/users'
    expect(page).to_not have_content 'notvalid@sheffield.ac.uk Admin'
  end

  specify 'I cannot create an account that already exists' do
    fill_in 'user_email', with: 'zjeng1@sheffield.ac.uk'
    select('User', :from => 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'Account already exists.'
    visit '/users'
    expect(page).to_not have_content 'notvalid@sheffield.ac.uk User'
  end

  specify 'I can view a list of users that exist in the database' do
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('Admin', :from => 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'User was successfully created.'
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk Admin'
    expect(page).to have_content 'zjeng1@sheffield.ac.uk Admin'
  end

  specify 'I can view the details of a user' do
    visit '/users'
    expect(page).to have_content 'zjeng1@sheffield.ac.uk Admin'
    click_link('View')
    expect(page).to have_content 'acb16zje'
    expect(page).to have_content 'COM'
  end

  specify 'I can delete a different user' do
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('Admin', :from => 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'User was successfully created.'
    click_link('Users')
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk Admin'
    expect(page).to have_content 'zjeng1@sheffield.ac.uk Admin'
    click_link('view_user_2')
    expect(page).to have_content 'aca16wkk'
    expect(page).to have_content 'COM'
    click_link('Edit Details')
    expect(page).to have_content 'Delete'
    click_link('Delete')
    expect(page).to have_content 'User was successfully deleted.'
    expect(page).to_not have_content 'wkkhaw1@sheffield.ac.uk Admin'
  end

  specify 'I cannot delete my own account' do
    click_link ('Users')
    expect(page).to have_content 'zjeng1@sheffield.ac.uk Admin'
    click_link('view_user_1')
    expect(page).to have_content 'acb16zje'
    expect(page).to have_content 'COM'
    click_link('Edit Details')
    expect(page).to_not have_content 'Delete'
  end
end
