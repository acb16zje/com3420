# == Schema Information
#
# Table name: user_home_categories
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  category_id :integer
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

class UserHomeCategory < ApplicationRecord
  belongs_to :user
  belongs_to :category
end
