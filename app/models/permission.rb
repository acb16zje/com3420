# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Permission < ApplicationRecord
end
