require 'rails_helper'
require 'spec_helper'

describe 'Managing login' do
  before :each do
    click_link('sign_out')
  end

  # Fill in your MUSE username and password to run and also fill your details in factories/users.rb
  specify 'I can login with correct email and password' do
    sign_in_using_email
    expect(page).to_not have_content 'Sign in'
  end

  specify 'I can login with correct email and password and then log out' do
    sign_in_using_email
    expect(page).to_not have_content 'Sign in'
    click_link('sign_out')
    expect(page).to_not have_content 'Sign Out'
    expect(page).to have_content 'Sign in'
  end

  # Fill in your MUSE email and password to run and also fill your details in factories/users.rb
  specify 'I can login with correct username and password' do
    sign_in_using_uid
    expect(page).to_not have_content 'Sign in'
  end

  specify 'I can login with correct username and password and then log out' do
    sign_in_using_uid
    expect(page).to_not have_content 'Sign in'
    click_link('sign_out')
    expect(page).to_not have_content 'Sign Out'
    expect(page).to have_content 'Sign in'
  end

  specify 'I cannot access pages without logging in' do
    visit '/items'
    expect(page).to have_content 'You need to sign in before continuing.'
  end

  specify 'I cannot login with wrong username' do
    sign_in_using_wrong_username
    expect(page).to have_content 'Invalid username or password.'
    expect(page).to_not have_content 'Sign Out'
  end

  specify 'I cannot login with wrong password' do
    sign_in_using_wrong_password
    expect(page).to have_content 'Invalid username or password.'
    expect(page).to_not have_content 'Sign Out'
  end
end
