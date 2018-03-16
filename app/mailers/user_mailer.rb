class UserMailer < ApplicationMailer


  def welcome (user)
    @user = user

    mail to: user.email, subject: "Welcome to AMRC online resource booking system"
  end


  def booking_approved (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Booking request for " + @item.name + " has been approved"
  end

  def booking_rejected (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Booking request for " + @item.name + " has been rejected"
  end

  def asset_due (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Item " + @item.name + "is due return today"
  end


  def asset_overdue (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Item " + @item.name + "has been due return"
  end

end
