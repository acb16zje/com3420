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

FactoryBot.define do
  factory :user_home_category do
    user_id 1
    category_id '1'
  end
end
