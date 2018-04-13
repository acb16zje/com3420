# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  phone              :string
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
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username)
#

FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:email) {|n| "atchapman1{n}@sheffield.ac.uk"}
    givenname 'Alex'
    sn 'Chapman'
    permission_id 3
    username 'aca16atc'
    phone ''
  end

  factory :erica, class: 'User' do
    email 'erica.smith@sheffield.ac.uk'
    username 'me1eds'
    givenname 'Erica'
    sn 'Smith'
    phone ''
    permission_id 3
  end

  factory :zerjun_admin, class: 'User' do
    email 'zjeng1@sheffield.ac.uk'
    username 'acb16zje'
    givenname 'Zer Jun'
    sn 'Eng'
    phone ''
    permission_id 3
  end

  factory :zerjun_asset_manager, class: 'User' do
    email 'zjeng1@sheffield.ac.uk'
    username 'acb16zje'
    givenname 'Zer Jun'
    sn 'Eng'
    phone ''
    permission_id 2
  end

  factory :zerjun_user, class: 'User' do
    email 'zjeng1@sheffield.ac.uk'
    username 'acb16zje'
    givenname 'Zer Jun'
    sn 'Eng'
    phone ''
    permission_id 1
  end
end
