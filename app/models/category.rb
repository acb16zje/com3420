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

class Category < ApplicationRecord
  validates :name, presence: true
  validates :has_peripheral, presence: true
  validates :is_peripheral, presence: true

  has_many :items
  has_many :users, through: :user_home_categories
end
