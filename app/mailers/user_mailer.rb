class UserMailer < ApplicationMailer


  def welcome (user)
    @user = user

    mail to: user.email, subject: "Welcome to AMRC online resource booking system"
  end

  def booking_approved (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Booking for asset: " + @item.asset_tag + ", " + @item.name + " has been approved"
  end

  def booking_ongoing (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Booking for asset: " + @item.asset_tag + ", " + @item.name + " has started"
  end

  def booking_late (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Asset: " + @item.asset_tag + ", " + @item.name + " is due to be returned."
  end

  def user_booking_requested (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Booking request for asset: " + @item.asset_tag + ", " + @item.name + " is being processed"
  end

  def manager_booking_requested (user, item, manager, booking)
    @user = user
    @item = item
    @manager = manager
    @booking = booking

    mail to: manager.email, subject: "Asset: " + @item.asset_tag + ", " + @item.name + " has been requested for booking."
  end

  def manager_asset_returned (user, item, manager)
    @user = user
    @item = item
    @manager = manager

    mail to: manager.email, subject: "Asset: " + @item.asset_tag + ", " + @item.name + " has been returned."
  end

  def manager_booking_cancelled (user, item, manager, booking)
    @user = user
    @item = item
    @manager = manager
    @booking = booking

    mail to: manager.email, subject: "Booking ID: " + @booking.id + " for asset:" + @item.asset_tag + ", " + @item.name + " has been cancelled."
  end

  def booking_rejected (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Booking for asset: " + @item.asset_tag + ", " + @item.name + " has been rejected."
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
