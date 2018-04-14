require 'rails_helper'
require 'spec_helper'

describe 'Managing categories' do
  before :each do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
  end

  specify 'I can create a category that does not exist yet with no icon' do
    create_cameras
  end

  specify 'I can create a category and then add a peripheral category for it later' do
    create_cameras
    visit '/categories'
    click_link('Create Peripheral Category')
    expect(page).to have_content 'Peripheral category successfully created'
  end

  specify 'I can create a category that does not exist yet with a material icon' do
    fill_in 'category_name', with: 'Alarms'
    fill_in 'category_icon', with: '<i class="material-icons">alarm</i>'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'Alarms'
  end

  specify 'I can create a category that does not exist yet with a font awesome icon' do
    fill_in 'category_name', with: 'Alarms'
    fill_in 'category_icon', with: '<i class="fas fa-clock"></i>'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'Alarms'
  end

  specify 'I cannot create a category that has an invalid name' do
    fill_in 'category_name', with: 'This category name is too long to meet requirements'
    click_button('Create category')
    expect(page).to have_content 'Category name does not meet requirements.'
  end

  specify 'I cannot create a category that already exists' do
    create_cameras
    create_cameras
    expect(page).to have_content 'Category already exists.'
  end

  specify 'I can create a category with a peripheral category' do
    fill_in 'category_name', with: 'Cameras'
    find(:css, "#want_peripheral[value='1']").set(true)
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'Cameras'
    expect(page).to have_content 'Cameras - Peripherals'
  end

  specify 'I can create a category with a peripheral category with a font awesome icon' do
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_icon', with: '<i class="fas fa-camera"></i>'
    find(:css, "#want_peripheral[value='1']").set(true)
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'Cameras'
    expect(page).to have_content 'Cameras - Peripherals'
  end

  specify 'I can update a category' do
    create_laptops
    visit '/categories'
    expect(page).to have_content 'Laptops'
    click_link('Edit')
    expect(page).to have_content 'Editing Laptops'
    fill_in 'category_name', with: 'Cameras'
    click_button('Save changes')
    expect(page).to have_content 'Category was successfully updated'
    expect(page).to have_content 'Cameras'
    expect(page).to_not have_content 'Laptops'
  end

  specify 'I can delete a category that no asset is using' do
    create_cameras
    visit '/categories'
    expect(page).to have_content 'Cameras'
    click_link('Delete')
    expect(page).to have_content 'Category was successfully deleted.'
    expect(page).to_not have_content 'Cameras'
  end

  specify 'I cannot delete a category that an asset is using' do
    create_cameras
    create_gopro
    visit '/categories'
    expect(page).to have_content 'Cameras'
    click_link('Delete')
    expect(page).to have_content 'Cannot delete category because it is currently in use for an asset.'
    expect(page).to have_content 'Cameras'
  end

  specify 'I can add favourite category to home page' do
    create_cameras
    visit '/'
    expect(page).to_not have_content 'View Cameras'
    click_link('Add Favourite')
    expect(page).to have_content 'Add Favourite Category'
    select('Cameras', from: 'user_home_category_category_id')
    click_button('Add Category')
    expect(page).to have_content 'View Cameras'
  end

  specify 'I can remove favourite category from home page' do
    create_cameras
    visit '/'
    expect(page).to_not have_content 'View Cameras'
    click_link('Add Favourite')
    expect(page).to have_content 'Add Favourite Category'
    select('Cameras', from: 'user_home_category_category_id')
    click_button('Add Category')
    expect(page).to have_content 'View Cameras'
    click_link('Manage Favourites')
    expect(page).to have_content 'My Favourites Category'
    expect(page).to have_content 'Remove'
    click_link('Remove')
    expect(page).to have_content 'Favourite category successfully removed'
  end

  specify 'I can delete a category that a user is using for a favourite, but no asset is using' do
    create_cameras
    visit '/categories'
    expect(page).to have_content 'Cameras'
    visit '/'
    expect(page).to_not have_content 'View Cameras'
    click_link('Add Favourite')
    expect(page).to have_content 'Add Favourite Category'
    select('Cameras', from: 'user_home_category_category_id')
    click_button('Add Category')
    expect(page).to have_content 'View Cameras'
    visit '/categories'
    click_link('Delete')
    expect(page).to have_content 'Category was successfully deleted.'
    expect(page).to_not have_content 'Cameras'
  end

  specify 'I can view all categories in the filter tab' do
    create_cameras
    visit '/categories'
    expect(page).to have_content 'Cameras'
    create_laptops
    visit '/categories'
    expect(page).to have_content 'Laptops'
    visit '/categories/filter'
    expect(page).to have_content 'Laptops'
    expect(page).to have_content 'Cameras'
  end
end
