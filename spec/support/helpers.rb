module Helpers
  # Signing in helpers
  def sign_in_details(using_email=false)
    @email = 'zjeng1@sheffield.ac.uk'
    @username = 'acb16zje'
    @password = 'Idpuk123'

    user = User.new
    user.email = @email
    user.username = @username
    user.permission_id = 3

    begin
      user.save
    rescue
    end

    visit '/users/sign_in'

    if using_email
      fill_in 'user_username', with: @email
    else
      fill_in 'user_username', with: @username
    end

    # Your password
    fill_in 'user_password', with: @password
    click_button 'Sign in'

    return user.username
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
    attach_file("item_image", Rails.root + 'app/assets/images/assets/gopro.jpg')
    click_button('Create asset')
  end

  def create_microsd_gopro
    select("GPH5 (GoPro Hero 5)", from: 'item_items_id')
    fill_in 'item_name', with: 'MicroSD Card'
    fill_in 'item_serial', with: 'SD322'
    fill_in 'item_location', with: 'Diamond'
    click_button('Create asset')
  end

  def create_microsd_gopro_choose
    visit '/items/new'  
    fill_in 'item_name', with: 'MicroSD Card'
    fill_in 'item_serial', with: 'SD322'
    fill_in 'item_location', with: 'Diamond'
    click_button('Create asset')
  end

  def create_peripheral_for_gopro
    create_cameras
    visit '/categories'
    click_link('Create Peripheral Category')
    create_gopro
    find(:css, '#add_peripheral').click
    click_link('Create')
    create_microsd_gopro
    visit '/items'
    click_link('GoPro Hero 5')
    click_link('MicroSD Card')
  end
end
