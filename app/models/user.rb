# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  forename           :string
#  surname            :string
#  password           :string
#  phone              :string
#  department         :string
#  permission_id      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  email              :string           default(""), not null
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :inet
#  last_sign_in_ip    :inet
#  username           :string
#  uid                :string
#  mail               :string
#  ou                 :string
#  dn                 :string
#  sn                 :string
#  givenname          :string
#
# Indexes
#
#  index_users_on_email     (email)
#  index_users_on_username  (username)
#

class User < ApplicationRecord
  
  
  include EpiCas::DeviseHelper
  
  
  end
