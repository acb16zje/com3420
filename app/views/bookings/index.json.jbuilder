json.recordsTotal @bookings.length.to_s
json.recordsFiltered @bookings.length.to_s
json.data do
  json.array! @bookings do |booking|
      json.method @method
      json.id booking.id.to_s
      json.start_date booking.start_date
      json.start_time booking.start_time
      json.end_date booking.end_date
      json.end_time booking.end_time
      #json.start_datetime booking.start_datetime
      #json.end_datetime booking.end_datetime
      json.reason booking.reason
      json.next_location booking.next_location
      json.status booking.status.to_s
      #json.created_at booking.created_at
      #json.updated_at booking.updated_at
      json.user_id booking.user_id.to_s
      json.items do
        json.array! booking.items do |item|
          json.item_id item.id.to_s
          json.item_name item.name
        end
      end
  end
end
