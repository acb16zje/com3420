class UserMailer < ApplicationMailer


  def welcome (user)
    @user = user
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: user.email, subject: "AMRC - Welcome: #{user.givenname} #{user.sn}"
  end

  def booking_approved (booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    @items = get_peripherals(booking)

    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @user.email, subject: "AMRC - Booking Confirmed: #{@item.name}"
  end

  def booking_ongoing (booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    @items = get_peripherals(booking)

    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @user.email, subject: "AMRC - Booking Started: #{@item.name}"
  end

  def user_booking_requested (booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    @items = get_peripherals(booking)
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")


    mail to: @user.email, subject: "AMRC - Booking Recieved: #{@item.name}"
    puts @items
  end

  def manager_booking_requested (booking)
    @booking = booking
    @user = @booking.user
    @item = @booking.item
    @manager = @item.user
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")
    @items = get_peripherals(booking)


    mail to: @manager.email, subject: "AMRC - Booking Requested: #{@item.name}"
  end

  def manager_asset_returned (booking)
    @booking = booking
    @user = @booking.user
    @item = @booking.item
    @manager = @item.user
    @items = get_peripherals(booking)

    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @manager.email, subject: "AMRC - Item Returned: #{@item.name}"
  end

  def manager_asset_issue (user, item)
    @user = user
    @item = item
    @manager = @item.user

    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @manager.email, subject: "AMRC - Item Issue: #{@item.name}"
  end

  def manager_booking_cancelled (booking)
    @booking = booking
    @user = @booking.user
    @item = @booking.item
    @manager = @item.user
    @items = get_peripherals(booking)

    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @manager.email, subject: "AMRC - Booking Cancelled: #{@item.name}"
  end

  def booking_rejected (booking)
    @booking = booking
    @user = @booking.user
    @item = @booking.item
    @manager = @item.user
    @items = get_peripherals(booking)

    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @user.email, subject: "AMRC - Booking Rejected: #{@item.name}"
  end

  def asset_due (booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    @manager = booking.item.user
    @items = get_peripherals(booking)

    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @user.email, subject: "AMRC - Return Due Soon: #{@item.name}"
  end


  def asset_overdue (booking)
    @booking = booking
    @user = booking.user
    @item = booking.item
    @manager = booking.item.user
    @items = get_peripherals(booking)
    attachments.inline["amrc_main.svg"] = File.read("#{Rails.root}/app/assets/images/amrc_main.svg")

    mail to: @user.email, subject: "AMRC - Late For Return: #{@item.name}"
  end

  def get_peripherals(booking)
    bookingitem = [Item.find(booking.item.id)]
    peripherals = Item.where(serial: booking.peripherals.to_s.split)
    return bookingitem + peripherals
  end
end
