# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag        :string
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#  index_categories_on_tag   (tag) UNIQUE
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
