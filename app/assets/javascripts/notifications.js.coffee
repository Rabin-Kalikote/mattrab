
class Notifications
  constructor: ->
    @notifications = $("[data-behavior='notifications']")
    @setup() if @notifications.length > 0

  setup: ->
    $("[data-behavior='open-n']").on "click", @handleClick
    $.ajax(
      url: '/notifications.json'
      dataType: 'JSON'
      method: 'GET'
      success: @handleSuccess
    )

  handleClick: (e) =>
    $.ajax(
      url: '/notifications/mark_as_read'
      dataType: 'JSON'
      method: 'POST'
      success: ->
        $("[data-behavior='unread-count']").text(0)
        $("[data-behavior='unread-count']").hide()
    )

  handleSuccess: (data) =>
    new_items = []
    earlier_items = []

    i = 0
    while i < data.length
      notification = data[i]
      if notification.type != undefined
        if notification.read_at != null
          earlier_items.push "<a class='dropdown-item this-body mb-2' href='#{notification.url}'>
            <div class='row'>
              <div class='col-md-2 col-sm-2 col-xs-2'>
                <div class='n-img'>
                  <img src='#{notification.actor.avatar}'>
                </div>
              </div>
              <div class='col-md-10 col-sm-10 col-xs-10 pd-l0'>
                <p>#{notification.actor.name} #{notification.action} #{notification.type}</p>
                <span>#{notification.created_at}</span>
              </div>
            </div>
          </a>"
        else
          new_items.push "<a class='dropdown-item this-body mb-2' href='#{notification.url}'>
            <div class='row'>
              <div class='col-md-2 col-sm-2 col-xs-2'>
                <div class='n-img'>
                  <img src='#{notification.actor.avatar}'>
                </div>
              </div>
              <div class='col-md-10 col-sm-10 col-xs-10 pd-l0'>
                <p>#{notification.actor.name} #{notification.action} #{notification.type}</p>
                <span>#{notification.created_at}</span>
              </div>
            </div>
          </a>"
      i++

    if new_items.length != 0
      $("[data-behavior='unread-count']").text(new_items.length)
    $("[data-behavior='new-notification-items']").append(new_items)
    $("[data-behavior='earlier-notification-items']").append(earlier_items)


jQuery ->
  new Notifications
