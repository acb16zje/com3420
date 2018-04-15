require 'rails_helper'
require 'spec_helper'

describe 'Managing assets' do
  specify 'I can create asset with complete details' do
    FactoryBot.create :laptop_category
    create_macbook_pro
    visit '/items'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link('Macbook Pro 15-inch')
    expect(page).to have_content 'Western Bank Library'
    expect(page).to have_content 'Book or Reserve'
  end

  specify 'I can create a peripheral for an asset' do
    create_cameras
    visit '/categories'
    click_link('Create Peripheral Category')
    create_gopro
    click_link('Add / Edit Peripherals')
    click_link('Create')
    create_microsd_gopro
    visit '/items'
    click_link('GoPro Hero 5')
    click_link('MicroSD Card')
  end

  specify 'I can edit an asset that belongs to me' do
    FactoryBot.create(:macbook_pro, :item_belongs_to_existing_user)
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

  specify 'My assets does not show assets that do not belong to me' do
    FactoryBot.create :erica
    FactoryBot.create :macbook_pro
    visit '/items/manager?user_id=2'
    expect(page).to_not have_content 'Macbook Pro 15-inch'
  end

  specify 'I cannot edit an asset that does not belong to me' do
    FactoryBot.create :laptop_erica
    visit '/items/manager?user_id=2'
    expect(page).to_not have_css("#edit-button-1")
    expect(page).to_not have_content 'Set Condition'
    visit '/items'
    expect(page).to have_content 'Macbook Pro 15-inch'
    click_link('Macbook Pro 15-inch')
    expect(page).to_not have_css("#edit_item_1")
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
    create_weikin_user
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
end
