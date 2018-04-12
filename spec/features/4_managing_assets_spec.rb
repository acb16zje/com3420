require 'rails_helper'
require 'spec_helper'

describe 'Managing assets' do
  before :each do

  end

  specify 'I can create asset with complete details' do
    FactoryBot.create :laptop_category
    visit '/items/new'
    expect(page).to have_content 'Create asset'
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
    visit '/items'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link('Macbook Pro 15-inch')
    expect(page).to have_content 'Western Bank Library'
    expect(page).to have_content 'Acquisition Date'
    expect(page).to have_content 'Book or Reserve'
  end

  specify 'I can create an asset with incomplete details' do
    FactoryBot.create :laptop_category
    visit '/items/new'
    expect(page).to have_content 'Create asset'
    fill_in 'item_name', with: 'Macbook Pro 13-inch'
    select('Laptops', from: 'item_category_id')
    fill_in 'item_location', with: 'Western Bank Library'
    click_button('Create asset')
    visit '/items'
    expect(page).to have_content 'Macbook Pro 13-inch'
    click_link('Macbook Pro 13-inch')
    expect(page).to have_content 'Acquisition Date'
    expect(page).to have_content 'Book or Reserve'
  end

  specify 'I can edit an asset that belongs to me' do
    FactoryBot.create(:laptop_item, :item_belongs_to_existing_user)

    visit '/items'

    expect(page).to have_content 'Macbook Pro 13-inch'
    click_link('Macbook Pro 13-inch')

    expect(page).to_not have_content 'Apple'
    expect(page).to have_content 'Edit'

    click_link('Edit')

    expect(page).to have_content 'Editing Macbook Pro 13-inch'

    fill_in 'item_manufacturer', with: 'Apple'
    click_button 'Save changes'

    expect(page).to have_content 'Asset was successfully updated'
    expect(page).to have_content 'Manufacturer Apple'
    expect(page).to have_content 'Western Bank Library'
  end

  specify 'My assets does not show assets that do not belong to me' do
    FactoryBot.create(:laptop_item)
    visit '/items/manager?user_id=1'
    expect(page).to_not have_content 'Macbook Pro 13-inch'
  end

  specify 'I cannot edit an asset that does not belong to me' do
    FactoryBot.create(:laptop_item)
    visit '/items/manager?user_id=2'
    expect(page).to_not have_css("#edit-button-1")
    expect(page).to_not have_content 'Set Condition'
    visit '/items'
    expect(page).to have_content 'Macbook Pro 13-inch'
    click_link('Macbook Pro 13-inch')
    expect(page).to_not have_css("#edit_item_1")
  end

  specify 'I can delete an asset' do
    FactoryBot.create :laptop_category
    visit '/items/new'
    expect(page).to have_content 'Create asset'
    fill_in 'item_name', with: 'Macbook Pro 13-inch'
    select('Laptops', from: 'item_category_id')
    fill_in 'item_location', with: 'Western Bank Library'
    click_button('Create asset')
    visit '/items'
    expect(page).to have_content 'Macbook Pro 13-inch'
    click_link('Macbook Pro 13-inch')
    expect(page).to_not have_content 'Apple'
    expect(page).to have_content 'Edit'
    click_link('Edit')
    expect(page).to have_content 'Delete'
    click_link('Delete')
    expect(page).to have_content 'Asset was successfully deleted'
    expect(page).to_not have_content 'Macbook Pro 13-inch'
  end

  specify 'I can view the list of my assets' do
    FactoryBot.create :laptop_category
    visit '/items/new'
    expect(page).to have_content 'Create asset'
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
    visit '/items'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link('Macbook Pro 15-inch')
    expect(page).to have_content 'Western Bank Library'
    expect(page).to have_content 'Acquisition Date'
    expect(page).to have_content 'Book or Reserve'
    click_link('My Assets')
    expect(page).to have_content 'My Assets'
    expect(page).to have_content 'Macbook Pro 15-inch'
  end

  specify 'I can transfer the ownership of my asset' do
    FactoryBot.create :laptop_category
    visit '/items/new'
    expect(page).to have_content 'Create asset'
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
    visit '/users/new'
    fill_in 'user_email', with: 'wkkhaw1@sheffield.ac.uk'
    select('User', from: 'user_permission_id')
    click_button('Create user')
    expect(page).to have_content 'User was successfully created.'
    visit '/items'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link('Macbook Pro 15-inch')
    expect(page).to have_content 'Western Bank Library'
    expect(page).to have_content 'Acquisition Date'
    expect(page).to have_content 'Book or Reserve'
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
end
