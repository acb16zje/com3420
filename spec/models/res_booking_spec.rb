# == Schema Information
#
# Table name: res_bookings
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  user_email :string
#  manager_id :integer
#  out_date   :datetime
#  in_date    :datetime
#  comments   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ResBooking, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
