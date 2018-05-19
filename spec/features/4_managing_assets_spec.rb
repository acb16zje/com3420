require 'rails_helper'
require 'spec_helper'

describe 'Managing assets' do
  specify 'I can create asset with complete details' do
    FactoryBot.create :laptop_category
    create_macbook_pro
    visit '/items'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link 'Macbook Pro 15-inch'
    expect(page).to have_content 'Western Bank Library'
    expect(page).to have_content 'Book or Reserve'
  end

  specify 'I cannot create two assets with same serial' do
    FactoryBot.create :laptop_category
    create_macbook_pro
    create_macbook_pro
  end

  specify 'I can create a peripheral for an asset' do
    create_peripheral_for_gopro
  end

  specify 'I can choose a peripheral for an asset' do
    create_cameras
    visit '/categories'
    click_link 'Create Peripheral Category'
    create_microsd_gopro_choose
    create_gopro
    find(:css, '#add_peripheral').click
    click_link 'Choose'
    select("MicroSD Card (SD322)", from: 'item_add_peripherals')
    click_button 'Add as Peripheral'
  end

  specify 'I cannot choose the parent asset to be a peripheral for an asset ' do
    create_cameras
    visit '/categories'
    click_link 'Create Peripheral Category'
    create_microsd_gopro_choose
    create_gopro
    find(:css, '#add_peripheral').click
    click_link 'Choose'
    select("MicroSD Card (SD322)", from: 'item_add_peripherals')
    click_button 'Add as Peripheral'
    visit '/items/2'
    find(:css, '#add_peripheral').click
    click_link 'Choose'
  end

  specify 'I can remove a parent and add a new parent for an asset' do
    create_laptops
    create_macbook_pro
    create_peripheral_for_gopro
    click_link 'Edit'
    unselect('GoPro Hero 5 (GPH5)', from: 'item_add_parents')
    select('Macbook Pro 15-inch (MPTR212/A)', from: 'item_add_parents')
    click_button 'Save changes'
    visit '/items/3'
    find(:css, '#add_peripheral').click
    click_link 'Choose'
  end

  specify "I cannot add the peripheral of an asset as it's parent" do
    create_peripheral_for_gopro
    create_laptops
    create_macbook_pro
    visit '/items/2'
    find(:css, '#add_peripheral').click
    click_link 'Choose'
    select('Macbook Pro 15-inch (MPTR212/A)', from: 'item_add_peripherals')
    click_button 'Add as Peripheral'
    visit '/items/2'
    click_link 'Edit'
  end

  specify 'I can edit an asset that belongs to me' do
    FactoryBot.create :macbook_pro
    visit '/items'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link('Macbook Pro 15-inch')
    expect(page).to_not have_content 'Apple'
    expect(page).to have_content 'Edit'
    click_link('Edit')
    expect(page).to have_content 'Editing Macbook Pro 15-inch'
    fill_in 'item_manufacturer', with: 'Apple'
    click_button 'Save changes'
    expect(page).to have_content 'Asset was successfully updated'
    expect(page).to have_content 'Manufacturer Apple'
  end

  specify 'I can set an asset to retired and unset it' do
    create_cameras
    create_gopro
    click_link 'Edit'
    select('Retired', from: 'item_condition')
    click_button 'Save changes'
    click_link 'Edit'
    select('Like New', from: 'item_condition')
    click_button 'Save changes'
  end

  specify 'My Assets only show assets that belongs to me' do
    FactoryBot.create :admin
    FactoryBot.create :macbook_pro
    visit '/items/manager?user_id=2'
    expect(page).to_not have_content 'Macbook Pro 15-inch'
  end

  specify 'I cannot edit an asset serial to the one already exist' do
    FactoryBot.create :macbook_pro_charging_cable
    visit '/items'
    click_link('Macbook Pro 15-inch')
    click_link('Edit')
    fill_in 'item_serial', with: 'CC322'
    click_button 'Save changes'
    expect(page).to have_content 'Serial already exist'
  end

  specify 'I can delete an asset' do
    FactoryBot.create :laptop_category
    create_macbook_pro
    visit '/items'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link('Macbook Pro 15-inch')
    expect(page).to have_content 'Edit'
    click_link('Edit')
    expect(page).to have_content 'Delete'
    click_link('Delete')
    expect(page).to have_content 'Asset was successfully deleted'
    expect(page).to_not have_content 'Macbook Pro 15-inch'
  end

  specify 'I can delete an asset after booking it' do
    FactoryBot.create :booking_today_all_day
    visit '/items'
    click_link('GoPro Hero 5')
    click_link('Edit')
    click_link('Delete')
    expect(page).to have_content 'Asset was successfully deleted'
    expect(page).to_not have_content 'GoPro Hero 5'
  end

  specify 'I can view the list of my assets' do
    FactoryBot.create :laptop_category
    create_macbook_pro
    visit '/items'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link('My Assets')
    expect(page).to have_content 'My Assets'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link('Out On Booking')
    click_link('Issue')
  end

  specify 'I can transfer the ownership of my asset' do
    FactoryBot.create :laptop_category
    create_macbook_pro
    create_weikin_admin
    visit '/items'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link('My Assets')
    expect(page).to have_content 'My Assets'
    expect(page).to have_content 'Macbook Pro 15-inch'
    find(:css, "#item_ids_[value='1']").set(true)
    click_button('Transfer Selection')
    expect(page).to have_content 'Transfer My Assets To'
    select('Wei Kin', from: 'item_user_id')
    click_button('Save changes')
    expect(page).to have_content 'Ownership was successfully transfered'
    expect(page).to_not have_content 'Macbook Pro 15-inch'
  end

  specify 'I can import assets from .xlsx file only' do
    visit '/items/import'
    attach_file("import_file_file", Rails.root + 'public/test.csv')
    click_button 'Import assets'
    expect(page).to have_content 'The submitted file is not of file .xlsx format'
    visit '/items/import'
    attach_file("import_file_file", Rails.root + 'public/test.xlsx')
    click_button 'Import assets'
    expect(page).to_not have_content 'The submitted file is not of file .xlsx format'
  end

  specify 'I cannot import excel sheets with the wrong header formats' do
    FactoryBot.create :camera_category
    visit '/items/import'
    attach_file("import_file_file", Rails.root + 'public/test1.xlsx')
    click_button 'Import assets'
    expect(page).to have_content 'Headers of excel sheet do not match appropriate format'
  end

  specify 'I can import assets that are in the correct format successfully' do
    FactoryBot.create :camera_category
    FactoryBot.create :camera_peripheral_category
    visit '/items/import'
    attach_file("import_file_file", Rails.root + 'public/test.xlsx')
    click_button 'Import assets'
    expect(page).to have_content 'Import was successful and no problems occured'
  end

  specify 'I cannot import assets that are not in the correct format successfully' do
    FactoryBot.create :camera_category
    FactoryBot.create :camera_peripheral_category
    FactoryBot.create :data_logger_category
    visit '/items/import'
    attach_file("import_file_file", Rails.root + 'public/test2.xlsx')
    click_button 'Import assets'
    expect(page).to have_content 'Import Errors'
    expect(page).to have_content "2 This row's NAME cell is either empty or does not follow the correct format"
    expect(page).to have_content "3 This row's SERIAL cell is either empty or does not follow the correct format"
    expect(page).to have_content "4 This row's CATEGORY cell is empty"
    expect(page).to have_content "5 This row's CATEGORY cell does not exist in the database"
    expect(page).to have_content "6 This row's CONDITION cell is either empty or does not follow the correct format"
    expect(page).to have_content "7 This row's ACQUISITION_DATE cell does not follow the correct format"
    expect(page).to have_content "8 This row's PURCHASE_PRICE cell does not follow the correct format"
    expect(page).to have_content "9 This row's LOCATION cell is either empty or does not follow the correct format"
    expect(page).to have_content "10 This row's MANUFACTURER cell does not follow the correct format"
    expect(page).to have_content "11 This row's MODEL cell does not follow the correct format"
    expect(page).to have_content "12 One of the peripheral assets in this row's PERIPHERALS cell does not exist in the database"
    expect(page).to have_content "13 This row's RETIRED_DATE cell either does not follow the correct format or CONDITION is not set to Retired"
    expect(page).to have_content "14 This row's PO_NUMBER cell does not follow the correct format"
    expect(page).to have_content "15 This row's COMMENT cell does not follow the correct format"
    expect(page).to have_content "16 This row's CATEGORY cell does not exist in the database"
    expect(page).to have_content "18 This row's SERIAL cell already exists in the database and is not unique"
    expect(page).to have_content "20 This row's KEYWORDS cell does not follow the correct format"
  end
end
