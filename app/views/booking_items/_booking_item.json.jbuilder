json.extract! booking_item, :id, :item_id, :booking_id, :created_at, :updated_at
json.url booking_item_url(booking_item, format: :json)
