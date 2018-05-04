# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/welcome
  def welcome
    UserMailer.welcome(User.find(2))
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/asset_due
  def asset_due
    b = CombinedBooking.first
    UserMailer.asset_due(b)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/asset_overdue
  def asset_overdue
    b = CombinedBooking.first
    UserMailer.asset_overdue(b)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/booking_approved
  def booking_approved
    b = CombinedBooking.first
    UserMailer.booking_approved(b.bookings)
  end

  def booking_ongoing
    b = CombinedBooking.first
    UserMailer.booking_ongoing(b)
  end

  def booking_rejected
    b = CombinedBooking.first
    UserMailer.booking_rejected(b.bookings)
  end

  def manager_asset_issue
    u = User.first
    i = Item.first
    UserMailer.manager_asset_issue(u, i)
  end

  def manager_asset_returned
    b = CombinedBooking.first
    UserMailer.user_booking_requested(b)
  end

  def manager_booking_cancelled
    b = CombinedBooking.first
    UserMailer.manager_booking_cancelled(b.bookings)
  end

  def manager_booking_overdue
    b = Booking.first
    UserMailer.manager_booking_overdue(b)
  end

  def manager_booking_requested
    b = CombinedBooking.first
    UserMailer.manager_booking_requested(b.sorted_bookings[0])
  end

  def user_asset_returned
    b = Booking.first
    UserMailer.user_asset_returned(b)
  end

  def user_booking_cancelled
    b = Booking.first
    UserMailer.user_booking_cancelled(b)
  end

  def user_booking_requested
    b = CombinedBooking.first
    UserMailer.user_booking_requested(b)
  end


end
