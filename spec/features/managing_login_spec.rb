require 'rails_helper'
require 'spec_helper'

describe 'Managing login' do
  before :each do
    click_link('sign_out')
  end

  # Fill in your MUSE username and password to run and also fill your details in factories/users.rb
  specify 'I can login with correct email and password' do
    visit '/users/sign_in'
    expect(page).to have_content 'Sign in'
    sign_in_as_zerjun_email
    click_button 'Sign in'
    expect(page).to_not have_content 'Sign in'
  end

  # Fill in your MUSE email and password to run and also fill your details in factories/users.rb
  specify 'I can login with correct username and password' do
    visit '/users/sign_in'
    expect(page).to have_content 'Sign in'
    sign_in_as_zerjun_uid
    click_button 'Sign in'
    expect(page).to_not have_content 'Sign in'
  end

  specify 'I cannot access pages without logging in' do
    visit '/users/sign_in'
    expect(page).to have_content 'Sign in'
    visit '/items'
    expect(page).to have_content 'You need to sign in before continuing.'
  end

  #Fill in your password
  specify 'I cannot login with wrong username' do
    visit '/users/sign_in'
    expect(page).to have_content 'Sign in'
    sign_in_as_wrong_username
    click_button 'Sign in'
    expect(page).to have_content 'Invalid username or password.'
  end

  specify 'I cannot login with wrong password' do
    visit '/users/sign_in'
    expect(page).to have_content 'Sign in'
    sign_in_as_wrong_password
    click_button 'Sign in'
    expect(page).to have_content 'Invalid username or password.'
  end
end
