module Helpers
  def sign_in_using_uid
    fill_in 'user_username', with: 'acb16zje'
    fill_in 'user_password', with: 'Idpuk123'
  end

  def sign_in_using_email
    fill_in 'user_username', with: 'acb16zje'
    fill_in 'user_password', with: 'Idpuk123'
  end

  def sign_in_using_wrong_username
    fill_in 'user_username', with: 'wrongusername'
    fill_in 'user_password', with: 'correctpassword'
  end

  def sign_in_using_wrong_password
    fill_in 'user_username', with: 'zjeng1@sheffield.ac.uk'
    fill_in 'user_password', with: 'wrongpassword'
  end
end
