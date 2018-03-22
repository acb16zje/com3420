json.array! @notifications do |notification|
    json.recipient  "#{notification.recipient.givenname} #{notification.recipient.sn}"
    json.action notification.action
    json.context notification.context
    json.notifiable do
      json.type "#{notification.notifiable.class.to_s.underscore.humanize.downcase}"
      json.itemname "#{notification.notifiable.item.name.to_s}"
      json.booker "#{notification.notifiable.user.givenname.to_s} #{notification.notifiable.user.sn.to_s}"
    end

end
