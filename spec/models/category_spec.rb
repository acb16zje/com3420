# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string
#  icon           :string
#  has_peripheral :boolean
#  is_peripheral  :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "Validations" do
    describe "name" do
      it { should validate_presence_of(:name) }
    end
  end

  describe "Associations" do
    it { should have_many(:users).through(:user_home_category) }
    it { should have_many(:items) }
  end

  describe "Scopes" do

  end

  describe "Instance Methods" do

  end

  describe 'Insert into database' do
    it 'check for valid field values in the database' do
      category = Category.new(name: 'Cameras', icon: '<i class="fas fa-camera fa-6x></i>', has_peripheral: 0, is_peripheral: 0)
      expect(category.name).to eq 'Cameras'
      expect(category.icon).to eq '<i class="fas fa-camera fa-6x></i>'
      expect(category.has_peripheral).to eq false
      expect(category.is_peripheral).to eq false
    end
  end
end
