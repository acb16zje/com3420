class BookingDatatable < ApplicationDatatable

  private

  def data
    bookings.map do |booking|
      [].tap do |column|
        column << booking.id
        column << booking.start_date
        column << booking.start_time
        column << booking.end_date
        column << booking.end_time
        column << booking.reason
        column << booking.next_location
        column << booking.status
        column << booking.user_id
      end
    end
  end

  def count
    Booking.count
  end

  def total_entries
    bookings.total_count
    # will_paginate
    # users.total_entries
  end

  def bookings
    @bookings ||= fetch_bookings
  end

  def fetch_bookings
    search_string = []
    columns.each do |term|
      search_string << "cast(#{term} as text) like :search"
    end

    bookings = Booking.page(page).per(per_page)
    bookings = bookings.where(search_string.join(' or '), search: "%#{params[:search][:value]}%")
  end

  def columns
    %w(id start_date start_time end_date end_time reason next_location status user_id)
  end
end
