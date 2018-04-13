class UserMailer < ApplicationMailer


  def welcome (user)
    @user = user

    mail to: user.email, subject: "Welcome to AMRC online resource booking system"
  end

  def templateexample (user)
    @user = user
    puts "here"
    mail to: user.email, subject: "Test Mail"
  end

  def booking_approved (booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @user.email, subject: "Booking for asset: " + @item.name + ", " + @item.serial + " has been approved"
  end

  def booking_ongoing (booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @user.email, subject: "Booking for asset: " + @item.name + ", " + @item.serial + " has started"
  end

  def user_booking_requested (booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @user.email, subject: "Booking request for asset: " + @item.name + ", " + @item.serial + " is being processed"
  end

  def manager_booking_requested (user, item, manager, booking)
    @user = user
    @item = item
    @manager = manager
    @booking = booking

    mail to: manager.email, subject: "Asset: " + @item.name + ", " + @item.serial + " has been requested for booking."
  end

  def manager_asset_returned (user, item, manager)
    @user = user
    @item = item
    @manager = manager

    mail to: manager.email, subject: "Asset: " + @item.name + ", " + @item.serial + " has been returned."
  end

  def manager_booking_cancelled (user, item, manager, booking)
    @user = user
    @item = item
    @manager = manager
    @booking = booking

    mail to: manager.email, subject: "Booking ID: " + @booking.id + " for asset:" + @item.name + ", " + @item.serial + " has been cancelled."
  end

  def booking_rejected (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "Booking for asset: " + @item.name + ", " + @item.serial + " has been rejected."
  end

  def asset_due (booking, user, item)
    @booking = booking
    @user = user
    @item = item
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: user.email, subject: "AMRC - Return Due Soon: #{@item.name}"
  end


  def asset_overdue (booking, user, item)
    @booking = booking
    @user = user
    @item = item
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: user.email, subject: "AMRC - Late For Return: #{@item.name}"
  end

end
