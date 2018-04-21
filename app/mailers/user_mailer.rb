class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: user.email, subject: "AMRC - Welcome: #{user.givenname} #{user.sn}"
  end

  def booking_approved(booking)
    @booking = booking
    @user = booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Booking Confirmed"
  end

  def booking_ongoing(booking)
    @booking = booking
    @user = booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Booking Started"
  end

  def user_booking_requested(booking)
    @booking = booking
    @user = booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Booking Recieved"
  end

  def manager_booking_requested(booking)
    @booking = booking
    @user = @booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @manager.email, subject: "AMRC - Booking Requested"
  end

  def manager_asset_returned(booking)
    @booking = booking
    @user = @booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @manager.email, subject: "AMRC - Item Returned"
  end

  def manager_asset_issue(user, item)
    @user = user
    @item = item
    @manager = @item.user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @manager.email, subject: "AMRC - Item Issue"
  end

  def manager_booking_cancelled(booking)
    @booking = booking
    @user = @booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user


    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @manager.email, subject: "AMRC - Booking Cancelled"
  end

  def booking_rejected(booking)
    @booking = booking
    @user = @booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Booking Rejected"
  end

  def asset_due(booking)
    @booking = booking
    @user = booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user
    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Return Due Soon"
  end

  def asset_overdue(booking)
    @booking = booking
    @user = booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Late For Return"
  end

  def manager_booking_overdue(booking)
    @booking = booking
    @user = booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Late For Return"
  end

  def user_asset_returned(booking)
    @booking = booking
    @user = booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Booking Recieved"
  end

  def user_booking_cancelled(booking)
    @booking = booking
    @user = booking.user
    @items = @booking.getBookingItems
    @manager = @items[0].user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Booking Recieved"
  end

  def get_peripherals(booking)
    bookingitem = [Item.find(booking.item.id)]
    peripherals = Item.where(serial: booking.peripherals.to_s.split)

    bookingitem + peripherals
  end
end
