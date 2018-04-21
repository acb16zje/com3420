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
        $("[data-behavior='unread-count']").removeAttr('data-badge')
    )

  handleSuccess: (data) =>
    items = $.map data, (notification) ->
      if notification.context == "AM"
        if (notification.action == "returned") or (notification.action == "requested")
          "<a class='navbar-item'>#{notification.notifiable.booker} has #{notification.action}: #{notification.notifiable.itemname}</a>
          <hr class='navbar-divider>"
        else if (notification.action == "overdue")
          "<a class='navbar-item'>#{notification.notifiable.booker} has not returned #{notification.notifiable.itemname} on time</a>
          <hr class='navbar-divider>"
        else if (notification.action == "started") or (notification.action == "cancelled")
          "<a class='navbar-item'>#{notification.notifiable.booker}'s booking for #{notification.notifiable.itemname} has been #{notification.action}</a>
          <hr class='navbar-divider>"
        else if (notification.action == "reported")
          "<a class='navbar-item'>An issue has been reported with #{notification.notifiable.itemname}</a>
          <hr class='navbar-divider>"
      else if notification.context == "U"
        if (notification.action == "approved") or (notification.action == "rejected")
          "<a class='navbar-item'>Your #{notification.notifiable.type} for #{notification.notifiable.itemname} has been #{notification.action}</a>
          <hr class='navbar-divider>"
        else if (notification.action == "started")
          "<a class='navbar-item'>Your #{notification.notifiable.type} for #{notification.notifiable.itemname} has #{notification.action}</a>
          <hr class='navbar-divider>"
        else if (notification.action == "overdue")
          "<a class='navbar-item'>Your #{notification.notifiable.type} for #{notification.notifiable.itemname} is #{notification.action}</a>
          <hr class='navbar-divider>"
        else if (notification.action == "returned") or (notification.action == "cancelled")
          "<a class='navbar-item'>Your #{notification.notifiable.type} for #{notification.notifiable.itemname} has been #{notification.action}</a>
          <hr class='navbar-divider>"
    items_mobile = $.map data, (notification) ->
      if notification.context == "AM"
        if (notification.action == "returned") or (notification.action == "requested")
          "<a class='dropdown-item'>#{notification.notifiable.booker} has #{notification.action}: #{notification.notifiable.itemname}</a>
          <hr class='dropdown-divider>"
        else if (notification.action == "overdue")
          "<a class='dropdown-item'>#{notification.notifiable.booker} has not returned #{notification.notifiable.itemname} on time</a>
          <hr class='dropdown-divider>"
        else if (notification.action == "started") or (notification.action == "cancelled")
          "<a class='dropdown-item'>#{notification.notifiable.booker}'s booking for #{notification.notifiable.itemname} has been #{notification.action}</a>
          <hr class='dropdown-divider>"
        else if (notification.action == "reported")
          "<a class='dropdown-item'>An issue has been reported with #{notification.notifiable.itemname}</a>
          <hr class='dropdown-divider>"
      else if notification.context == "U"
        if (notification.action == "approved") or (notification.action == "rejected")
          "<a class='dropdown-item'>Your #{notification.notifiable.type} for #{notification.notifiable.itemname} has been #{notification.action}</a>
          <hr class='dropdown-divider>"
        else if (notification.action == "started")
          "<a class='dropdown-item'>Your #{notification.notifiable.type} for #{notification.notifiable.itemname} has #{notification.action}</a>
          <hr class='dropdown-divider>"
        else if (notification.action == "overdue")
          "<a class='navbar-item'>Your #{notification.notifiable.type} for #{notification.notifiable.itemname} is #{notification.action}</a>
          <hr class='dropdown-divider>"

    if items.length == 0
      $("[data-behavior='notification-items']").html("<a class='navbar-item'>No new notifications</a>")
      $("[data-behavior='notification-items-mobile']").html("<a class='dropdown-item'>No new notifications</a>")
      $("[data-behavior='unread-count']").removeAttr('data-badge')
    else
      $("[data-behavior='notification-items']").html(items_mobile)
      $("[data-behavior='unread-count']").attr('data-badge', items.length)


jQuery ->
  new Notifications
