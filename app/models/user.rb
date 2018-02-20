# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string
#  firstname  :string
#  surname    :string
#

class User < ApplicationRecord
end
