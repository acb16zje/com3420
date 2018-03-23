class Notifications
  constructor: ->
    @notifications = $("[data-behavior='notifications']")
    @setup() if @notifications.length > 0

  setup: ->
    $("[data-behavior='notification-link']").on "mouseover", @handleHover
    $.ajax(
      url: "/notifications.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  handleHover: (e) =>
    $.ajax(
      url: "/notifications/mark_as_read"
      dataType: "JSON"
      method: "POST"
      success: ->
        # $("[data-behavior='unread-count']").text("")
    )

  handleSuccess: (data) =>
    items = $.map data, (notification) ->
      if notification.context == "AM"
        if (notification.action == "returned") or (notification.action == "requested")
          "#{notification.notifiable.booker} has #{notification.action}: #{notification.notifiable.itemname}"
        else if (notification.action == "overdue")
          "#{notification.notifiable.booker} has not returned #{notification.notifiable.itemname} on time"
        else if (notification.action == "started") or (notification.action == "cancelled")
          "#{notification.notifiable.booker}'s booking for #{notification.notifiable.itemname} has been #{notification.action}"
      else if notification.context == "U"
        if (notification.action == "approved") or (notification.action == "rejected")
          "Your #{notification.notifiable.type} for #{notification.notifiable.itemname} has been #{notification.action}"
        else if (notification.action == "started")
          "Your #{notification.notifiable.type} for #{notification.notifiable.itemname} has #{notification.action}"
        else if (notification.action == "overdue")
          "Your #{notification.notifiable.type} for #{notification.notifiable.itemname} is #{notification.action}"

    $("[data-behavior='notification-items']").html(items)
    $("[data-behavior='unread-count']").text(items.length)
    if items.length == 0
      $("[data-behavior='unread-count']").text("")

jQuery ->
  new Notifications
