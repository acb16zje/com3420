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

    describe "icon" do

    end

    describe "has_peripheral" do
      it { should validate_presence_of(:has_peripheral) }
    end

    describe "is_peripheral" do
      it { should validate_presence_of(:is_peripheral) }
    end
  end

  describe "Associations" do
    it { should have_many(:users).through(:user_home_category)}
    it { should have_many(:items)}
  end

  describe "Scopes" do

  end

  describe "Instance Methods" do
    
  end
end
