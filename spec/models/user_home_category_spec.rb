# == Schema Information
#
# Table name: user_home_categories
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_home_categories_on_category_id  (category_id)
#  index_user_home_categories_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe UserHomeCategory, type: :model do
  it "is not valid without a user" do
    uhc = FactoryBot.create :user_home_category
    uhc.user = nil
    expect(uhc).to_not be_valid
  end

  it "is not valid without a category" do
    uhc = FactoryBot.create :user_home_category
    uhc.user = nil
    expect(uhc).to_not be_valid
  end

  describe "Associations" do
    it { should belong_to(:user)}
    it { should belong_to(:category)}
  end

  describe "Validations" do
    
  end
end
