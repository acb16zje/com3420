module Helpers
  # Signing in helpers
  def sign_in_using_uid
    fill_in 'user_username', with: ''
    fill_in 'user_password', with: ''
    click_button 'Sign in'
  end

  def sign_in_using_email
    fill_in 'user_username', with: ''
    fill_in 'user_password', with: ''
    click_button 'Sign in'
  end

  def sign_in_using_wrong_username
    fill_in 'user_username', with: 'wrongusername'
    fill_in 'user_password', with: 'correctpassword'
    click_button 'Sign in'
  end

  def sign_in_using_wrong_password
    fill_in 'user_username', with: 'zjeng1@sheffield.ac.uk'
    fill_in 'user_password', with: 'wrongpassword'
    click_button 'Sign in'
  end

  # Create users helpers
  def create_weikin_admin
    visit '/users/new'
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('Admin', from: 'user_permission_id')
    click_button('Create user')
  end

  def create_weikin_asset_manager
    visit '/users/new'
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('Asset Manager', from: 'user_permission_id')
    click_button('Create user')
  end

  def create_weikin_user
    visit '/users/new'
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('User', from: 'user_permission_id')
    click_button('Create user')
  end

  def create_erica
    visit 'users/new'
    fill_in 'user_email', with: 'erica.smith@sheffield.ac.uk'
    select('Admin', from: 'user_permission_id')
    click_button('Create user')
  end

  # Create assets helpers
  def create_macbook_pro

  end
end
