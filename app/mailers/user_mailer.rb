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

    mail to: @user.email, subject: "AMRC - Booking Confirmed: #{@item.name}"
  end

  def booking_ongoing (booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @user.email, subject: "AMRC - Booking Started: #{@item.name}"
  end

  def user_booking_requested (booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/ap
      p/assets/images/amrc_main.svg")

    mail to: @user.email, subject: "AMRC - Booking Recieved: #{@item.name}"
  end

  def manager_booking_requested (booking)
    @booking = booking
    @user = @booking.user
    @item = @booking.item
    @manager = @item.user
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @manager.email, subject: "AMRC - Booking Requested: #{@item.name}"
  end

  def manager_asset_returned (booking)
    @booking = booking
    @user = @booking.user
    @item = @booking.item
    @manager = @item.user
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @manager.email, subject: "AMRC - Item Returned: #{@item.name}"
  end

  def manager_booking_cancelled (booking)
    @booking = booking
    @user = @booking.user
    @item = @booking.item
    @manager = @item.user
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @manager.email, subject: "AMRC - Booking Cancelled: #{@item.name}"
  end

  def booking_rejected (user, item)
    @user = user
    @item = item

    mail to: user.email, subject: "AMRC - Booking Rejected: #{@item.name}"
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
