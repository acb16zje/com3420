# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  condition       :string
#  name            :string
#  location        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  manufacturer    :string
#  category_id     :integer
#  serial          :string
#  model           :string
#  aquisition_date :date
#  purchase_price  :decimal(, )
#
# Indexes
#
#  index_items_on_category_id  (category_id)
#

require 'rails_helper'

RSpec.describe Item, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
