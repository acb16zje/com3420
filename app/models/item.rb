# == Schema Information
#
# Table name: items
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  name             :string
#  condition        :string
#  location         :string
#  manufacturer     :string
#  model            :string
#  serial           :string
#  acquisition_date :string
#  purchase_price   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_items_on_user_id  (user_id)
#

class Item < ApplicationRecord
  belongs_to :category
  belongs_to :user
end
