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
        $("[data-behavior='unread-count']").text("")

    )

  handleSuccess: (data) =>
    console.log(data)
    items = $.map data, (notification) ->
      "Your #{notification.notifiable.type} for #{notification.notifiable.itemname} has #{notification.action}"
    $("[data-behavior='notification-items']").html(items)
    $("[data-behavior='unread-count']").text("")

jQuery ->
  new Notifications
