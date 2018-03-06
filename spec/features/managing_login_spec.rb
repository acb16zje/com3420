require 'rails_helper'
require 'spec_helper'

describe 'Managing categories' do
  # Fill in your MUSE username and password to run and also fill your details in factories/users.rb
  specify 'I can login with correct email and password' do
    visit '/users/sign_in'
    expect(page).to have_content 'Sign in'
    FactoryBot.create :user
    fill_in 'user_username', with: ''
    fill_in 'user_password', with: ''
    click_button 'Sign in'
    expect(page).to_not have_content 'Sign in'
  end

  # Fill in your MUSE email and password to run and also fill your details in factories/users.rb
  specify 'I can login with correct username and password' do
    visit '/users/sign_in'
    expect(page).to have_content 'Sign in'
    FactoryBot.create :user
    fill_in 'user_username', with: ''
    fill_in 'user_password', with: ''
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
    FactoryBot.create :user
    fill_in 'user_username', with: 'wrongusername'
    fill_in 'user_password', with: ''
    click_button 'Sign in'
    expect(page).to have_content 'Invalid username or password.'
  end

  specify 'I cannot login with wrong password' do
    visit '/users/sign_in'
    expect(page).to have_content 'Sign in'
    FactoryBot.create :user
    fill_in 'user_username', with: 'zjeng1@sheffield.ac.uk'
    fill_in 'user_password', with: 'wrongpassword'
    click_button 'Sign in'
    expect(page).to have_content 'Invalid username or password.'
  end
end
