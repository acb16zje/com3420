require 'rails_helper'
require 'spec_helper'

describe 'Managing categories' do

  specify 'I can create a category that does not exist yet' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'CAM Cameras'
  end

  specify 'I cannot create a category that has an invalid name' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'This category name is too long to meet requirements'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category name does not meet requirements.'
  end

  specify 'I cannot create a category that has an invalid name' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'C1AM'
    click_button('Create category')
    expect(page).to have_content 'Category tag does not meet requirements.'
  end

  specify 'I cannot create a category that already exists' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'CAM Cameras'
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'DoesNotExist'
    click_button('Create category')
    expect(page).to have_content 'Category or tag already exists.'
  end

  specify 'I cannot create a category that already exists' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'CAM Cameras'
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'DoesNotExist'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category or tag already exists.'
  end

  specify 'I cannot create a new category with a tag that already exists' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'CAM Cameras'
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'DoesNotExist'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category or tag already exists.'
  end

  specify 'I can update a category' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'CAM Cameras'
    click_link('Edit')
    expect(page).to have_content 'Editing Cameras'
    fill_in 'category_name', with: 'Camera'
    click_button('Save changes')
    expect(page).to have_content 'Category was successfully updated'
    expect(page).to have_content 'Camera'
    expect(page).to_not have_content 'Cameras'
  end

  specify 'I can delete a category' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'CAM Cameras'
    click_link('Delete')
    expect(page).to have_content 'Category was successfully destroyed.'
    expect(page).to_not have_content 'CAM Cameras'
  end

  specify 'I can add favourite category to home page' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'CAM Cameras'
    visit '/'
    expect(page).to_not have_content 'View Cameras'
    click_link('Add Favourite')
    expect(page).to have_content 'Add Favourite Category'
    select('Cameras', from: 'user_home_category_category_id')
    click_button('Add Category')
    expect(page).to have_content 'View Cameras'
  end

  specify 'I can remove favourite category from home page' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'CAM Cameras'
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
end
