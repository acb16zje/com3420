# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  forename   :string
#  surname    :string
#  email      :string
#  password   :string
#  phone      :string
#  department :string
#  permission :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
