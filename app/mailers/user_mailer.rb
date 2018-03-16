class UserMailer < ApplicationMailer


  def welcome (user)
    @user = user

    mail to: user.email, subject: "Welcome to AMRC online resource booking system"
  end


  def booking_approved (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Booking confirmation for " + @item.name + " has been approved"
  end

  def user_booking_requested (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Booking request for " + @item.name + " is being processed"
  end

  def manager_booking_requested (user, item, manager)
    @user = user
    @item = item
    @manager = manager

    mail to: manager.email, subject: "Booking request for " + @item.name + " is being processed"
  end

  def booking_rejected (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Booking rejection for " + @item.name + " has been rejected"
  end

  def asset_due (booking, user, item)
    @booking = booking
    @user = user
    @item = item

    mail to: user.email, subject: "Item " + @item.name + "is due return today"
  end


  def asset_overdue (booking, user, item)
    @booking = booking
    @user = user
    @item = item

    mail to: user.email, subject: "Item " + @item.name + "has been due return"
  end

end
