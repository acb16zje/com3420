# # require 'rails_helper'

# describe 'Managing products' do
#   specify 'I can add a product' do
#     visit '/'
#     click_link 'New Product'
#     fill_in 'Name', with: 'Toaster'
#     fill_in 'Description', with: 'Kenwood - 500 watt'
#     fill_in 'Cost', with: '29.99'
#     click_button 'Create Product'
#     expect(page).to have_content 'Product was successfully created.'
#     within(:css, 'table') {
#       expect(page).to have_content 'Kenwood - 500
#       watt'
#     }
#   end

#   specify 'I can edit a product' do
#     FactoryGirl.create :product
#     visit '/'
#     click_link 'Edit'
#     fill_in 'Name', with: 'Toaster'
#     fill_in 'Description', with: 'Benwood - 500 watt'
#     fill_in 'Cost', with: '29.99'
#     click_button 'Update Product'
#     expect(page).to have_content 'Product was successfully updated.'
#     visit '/'
#     within(:css, 'table') {
#       expect(page).to have_content 'Benwood - 500
#       watt'
#     }
#   end

#   specify 'I can see a list of products' do
#   end

#   specify 'I can search for a product' do
#   end

#   specify 'I can delete a product' do
#   end

#   specify 'I assign a category to a product' do
#   end
# end
