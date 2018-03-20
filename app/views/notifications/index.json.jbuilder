json.array! @notifications do |notification|
    json.recipient notification.recipient
    json.action notification.action
    json.notifiable do
      json.type "#{notification.notifiable.class.to_s.underscore.humanize.downcase}"
      json.itemname "#{notification.notifiable.item.name.to_s}"
    end

end
