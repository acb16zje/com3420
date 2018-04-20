class BookingItemDatatable < ApplicationDatatable

  private

  def data
    bookinngitem.map do |bi|
      [].tap do |column|
        column << bookinngitem.item.id
        column << bookinngitem.item.name
      end
    end
  end

  def count
    BookingItem.count
  end

  def total_entries
    bookinngitem.total_count
    # will_paginate
    # users.total_entries
  end

  def bookings
    @bookingitems ||= fetch_bookingitems
  end

  def fetch_bookingitems
    search_string = []
    columns.each do |term|
      search_string << "cast(#{term} as text) like :search"
    end

    bookingitems = BookingItem.page(page).per(per_page)
    bookingitems = bookings.where(search_string.join(' or '), search: "%#{params[:search][:value]}%")
  end

  def columns
    %w(id name)
  end
end
