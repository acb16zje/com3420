# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/welcome
  def welcome
    UserMailer.welcome(User.find(2))
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/booking_approved
  def booking_approved
    UserMailer.booking_approved
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/asset_due
  def asset_due
    UserMailer.asset_due
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/asset_overdue
  def asset_overdue
    UserMailer.asset_overdue
  end

end