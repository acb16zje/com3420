require 'rails_helper'
require 'spec_helper'

describe 'Managing categories' do
  before :each do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
  end

  specify 'I can create a category that does not exist yet' do
    fill_in 'category_name', with: 'Cameras'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'Cameras'
    visit '/categories/new'
    fill_in 'category_name', with: 'Alarms'
    fill_in 'category_icon', with: '<i class="material-icons">alarm</i>'
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
    fill_in 'category_name', with: 'Cameras'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'Cameras'
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    click_button('Create category')
    expect(page).to have_content 'Category already exists.'
  end

  specify 'I can update a category' do
    FactoryBot.create :laptop_category
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
    FactoryBot.create :camera_category
    visit '/categories'
    expect(page).to have_content 'Cameras'
    click_link('Delete')
    expect(page).to have_content 'Category was successfully deleted.'
    expect(page).to_not have_content 'Cameras'
  end

  specify 'I cannot delete a category that an asset is using' do
    FactoryBot.create :camera_category
    visit '/categories'
    expect(page).to have_content 'Cameras'
    FactoryBot.create :gopro
    click_link('Delete')
    expect(page).to have_content 'Cannot delete category because it is currently in use for an asset.'
    expect(page).to have_content 'Cameras'
  end

  specify 'I can add favourite category to home page' do
    fill_in 'category_name', with: 'Cameras'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'Cameras'
    visit '/'
    expect(page).to_not have_content 'View Cameras'
    click_link('Add Favourite')
    expect(page).to have_content 'Add Favourite Category'
    select('Cameras', from: 'user_home_category_category_id')
    click_button('Add Category')
    expect(page).to have_content 'View Cameras'
  end

  specify 'I can remove favourite category from home page' do
    fill_in 'category_name', with: 'Cameras'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'Cameras'
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
    FactoryBot.create :camera_category
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
    FactoryBot.create :camera_category
    visit '/categories'
    expect(page).to have_content 'Cameras'
    FactoryBot.create :laptop_category
    visit '/categories'
    expect(page).to have_content 'Laptops'
    visit '/categories/filter'
    expect(page).to have_content 'Laptops'
    expect(page).to have_content 'Cameras'
  end


end
