module Helpers
  # Signing in helpers
  def sign_in_using_uid
    visit '/users/sign_in'
    fill_in 'user_username', with: ''
    fill_in 'user_password', with: ''
    click_button 'Sign in'
  end

  def sign_in_using_email
    visit '/users/sign_in'
    fill_in 'user_username', with: ''
    fill_in 'user_password', with: ''
    click_button 'Sign in'
  end

  def sign_in_using_wrong_username
    visit '/users/sign_in'
    fill_in 'user_username', with: 'wrongusername'
    fill_in 'user_password', with: 'correctpassword'
    click_button 'Sign in'
  end

  def sign_in_using_wrong_password
    visit '/users/sign_in'
    fill_in 'user_username', with: 'zjeng1@sheffield.ac.uk'
    fill_in 'user_password', with: 'wrongpassword'
    click_button 'Sign in'
  end

  # Create users helpers
  def create_invalid_email
    visit '/users/new'
    fill_in 'user_email', with: 'notvalid@sheffield.ac.uk'
    click_button('Create user')
  end

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

  # Create categories helpers
  def create_cameras
    visit '/categories/new'
    fill_in 'category_name', with: 'Cameras'
    click_button('Create category')
    expect(page).to have_content 'Cameras'
  end

  def create_laptops
    visit '/categories/new'
    fill_in 'category_name', with: 'Laptops'
    click_button('Create category')
    expect(page).to have_content 'Laptops'
  end

  # Create assets helpers
  def create_macbook_pro
    visit '/items/new'
    fill_in 'item_name', with: 'Macbook Pro 15-inch'
    select('Laptops', from: 'item_category_id')
    fill_in 'item_location', with: 'western bank library'
    fill_in 'item_keywords', with: 'expensive lightweight macos'
    fill_in 'item_manufacturer', with: 'Apple'
    fill_in 'item_model', with: 'MacBookPro14,3'
    fill_in 'item_serial', with: 'MPTR212/A'
    fill_in 'purchaseDate', with: '22 March 2018'
    fill_in 'item_purchase_price', with: '2349.00'
    click_button('Create asset')
  end

  def create_gopro
    visit '/items/new'
    fill_in 'item_name', with: 'GoPro Hero 5'
    select('Cameras', from: 'item_category_id')
    fill_in 'item_location', with: 'Diamond'
    fill_in 'item_serial', with: 'GPH5'
    click_button('Create asset')
  end
end
