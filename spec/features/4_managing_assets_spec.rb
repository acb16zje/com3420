require 'rails_helper'
require 'spec_helper'

describe 'Managing assets' do
  before :each do
    FactoryBot.create :category
    visit '/items/new'
    expect(page).to have_content 'Create asset'
  end

  specify 'I can create asset with complete details' do
    fill_in 'item_name', with: 'Macbook Pro 15-inch'
    select('Laptops', from: 'item_category_id')
    fill_in 'item_location', with: 'Western Bank Library'
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
    expect(page).to have_content 'Acquisition Date'
    expect(page).to have_content 'Book or Reserve'
  end

  specify 'I can create an asset with incomplete details' do
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

  specify 'I can edit an asset' do
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
    expect(page).to have_content 'Editing Macbook Pro 13-inch'
    fill_in 'item_manufacturer', with: 'Apple'
    click_button 'Save changes'
    expect(page).to have_content 'Item was successfully updated'
    expect(page).to have_content 'Manufacturer Apple'
  end
end
