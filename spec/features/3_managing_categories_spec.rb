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

  specify 'I can delete a category' do
    visit '/categories/new'
    expect(page).to have_content 'Create category'
    fill_in 'category_name', with: 'Cameras'
    fill_in 'category_tag', with: 'CAM'
    click_button('Create category')
    expect(page).to have_content 'Category was successfully created.'
    expect(page).to have_content 'CAM Cameras'
    click_link('delete_category_1')
    expect(page).to have_content 'Category was successfully destroyed.'
    expect(page).to_not have_content 'CAM Cameras'
  end
end
