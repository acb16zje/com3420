# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string
#  tag            :string
#  icon           :string
#  has_peripheral :boolean
#  is_peripheral  :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#  index_categories_on_tag   (tag) UNIQUE
#

class Category < ApplicationRecord
  has_many :items
  has_many :users, through: :user_home_categories
end
