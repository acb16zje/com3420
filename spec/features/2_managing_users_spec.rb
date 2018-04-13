require 'rails_helper'
require 'spec_helper'

describe 'Managing accounts' do
  before :each do
    visit '/users/new'
    expect(page).to have_content 'Create user'
  end

  specify 'I can create an account with a MUSE email with the user permission status' do
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('User', from: 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'User was successfully created.'
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk User'
  end

  specify 'I can create an account with a MUSE email with the asset manager permission status' do
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('Asset Manager', from: 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'User was successfully created.'
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk Asset Manager'
  end

  specify 'I can create an account with a MUSE email with the admin permission status' do
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('Admin', from: 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'User was successfully created.'
    visit '/users'
    expect(page).to have_content 'wkkhaw1@sheffield.ac.uk Admin'
  end

  specify 'I cannot create an account with a non valid MUSE email' do
    fill_in 'user_email', with: 'notvalid@sheffield.ac.uk'
    select('Admin', from: 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'Not a valid email.'
    visit '/users'
    expect(page).to_not have_content 'notvalid@sheffield.ac.uk Admin'
  end

  specify 'I cannot create an account that already exists' do
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('User', from: 'user_permission_id')
    click_button('Create user')
    visit '/users/new'
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('Admin', from: 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'Account already exists.'
  end

  specify 'I can view a list of users that exist in the database' do
    FactoryBot.create :erica
    visit '/users'
    expect(page).to have_content 'erica.smith@sheffield.ac.uk Admin'
  end

  specify 'I can view the details of a user' do
    FactoryBot.create :erica
    visit '/users'
    expect(page).to have_content 'erica.smith@sheffield.ac.uk Admin'
    click_link('view_user_me1eds')
    expect(page).to have_content 'me1eds'
  end

  specify 'I can edit my profile details' do
    visit '/users'
    click_link('View')
    expect(page).to_not have_content '07578737404'
    expect(page).to have_content 'COM'
    expect(page).to have_content 'Edit Details'
    click_link('Edit Details')
    expect(page).to have_content 'Edit My Details'
    fill_in 'number', with: '07578737404'
    click_button('Save changes')
    expect(page).to have_content 'User was successfully updated'
    expect(page).to have_content '07578737404'
  end

  specify 'I can delete a different user' do
    FactoryBot.create :erica
    visit '/users'
    click_link('view_user_me1eds')
    expect(page).to have_content 'me1eds'
    click_link('Edit Details')
    expect(page).to have_content 'Delete'
    click_link('Delete')
    expect(page).to have_content 'User was successfully deleted.'
    expect(page).to_not have_content 'erica.smith@sheffield.ac.uk Admin'
  end

  specify 'I cannot delete my own account' do
    click_link 'Users'
    expect(page).to have_content 'zjeng1@sheffield.ac.uk Admin'
    click_link('view_user_acb16zje')
    expect(page).to have_content 'COM'
    click_link('Edit Details')
    expect(page).to_not have_content 'Delete'
  end

  specify 'I can view the list of asset managers' do
    FactoryBot.create :erica
    click_link 'Asset Managers'
    expect(page).to have_content 'erica.smith@sheffield.ac.uk'
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
  end
end
