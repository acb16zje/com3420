class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: user.email, subject: "AMRC - Welcome: #{user.givenname} #{user.sn}"
  end

  def booking_approved(booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    @items = get_peripherals(booking)

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Booking Confirmed: #{@item.name}"
  end

  def booking_ongoing(booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    @items = get_peripherals(booking)

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Booking Started: #{@item.name}"
  end

  #Takes CombinedBooking - UPDATED
  def user_booking_requested(booking)
    @booking = booking
    @user = booking.user
    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Booking Recieved"
  end

  #Takes array of bookings - UPDATED
  def manager_booking_requested(bookings)
    @booking = bookings[0]
    @user = @booking.user
    @items = bookings.map {|b| b.item}
    @manager = bookings[0].item.user
    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @manager.email, subject: "AMRC - Booking Requested"
  end

  #Takes array of bookings - UPDATED
  def manager_asset_returned(booking)
    @booking = bookings[0]
    @user = @booking.user
    @items = bookings.map {|b| b.item}
    @manager = bookings[0].item.user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @manager.email, subject: "AMRC - Item Returned"
  end

  def manager_asset_issue(user, item)
    @user = user
    @item = item
    @manager = @item.user

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @manager.email, subject: "AMRC - Item Issue: #{@item.name}"
  end

  def manager_booking_cancelled(booking)
    @booking = booking
    @user = @booking.user
    @item = @booking.item
    @manager = @item.user
    @items = get_peripherals(booking)

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @manager.email, subject: "AMRC - Booking Cancelled: #{@item.name}"
  end

  def booking_rejected(booking)
    @booking = booking
    @user = @booking.user
    @item = @booking.item
    @manager = @item.user
    @items = get_peripherals(booking)

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Booking Rejected: #{@item.name}"
  end

  def asset_due(booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    @manager = booking.item.user
    @items = get_peripherals(booking)

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Return Due Soon: #{@item.name}"
  end

  def asset_overdue(booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    @manager = booking.item.user
    @items = get_peripherals(booking)

    attachments.inline['amrc_main.png'] = File.read("#{Rails.root}/app/assets/images/amrc_main.png")

    mail to: @user.email, subject: "AMRC - Late For Return: #{@item.name}"
  end

  def get_peripherals(booking)
    bookingitem = [Item.find(booking.item.id)]
    # peripherals = Item.where(serial: booking.peripherals.to_s.split)
    peripherals = Item.where('items_id = ?', @item.id)

    bookingitem + peripherals
  end
end
