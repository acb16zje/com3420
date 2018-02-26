# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  forename      :string
#  surname       :string
#  email         :string
#  password      :string
#  phone         :string
#  department    :string
#  permission_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class User < ApplicationRecord
end
