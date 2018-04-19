
json.array! @bookings do |booking|
    json.id booking.id
    json.start_date booking.start_date
    json.start_time booking.start_time
    json.end_date booking.end_date
    json.end_time booking.end_time
    #json.start_datetime booking.start_datetime
    #json.end_datetime booking.end_datetime
    json.reason booking.reason
    json.next_location booking.next_location
    json.status booking.status
    #json.created_at booking.created_at
    #json.updated_at booking.updated_at
    json.user_id booking.user_id
end
