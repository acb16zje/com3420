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
    b = Booking.first
    UserMailer.asset_due(b, b.user, b.item)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/asset_overdue
  def asset_overdue
    b = Booking.first
    UserMailer.asset_overdue(b, b.user, b.item)
  end

end
