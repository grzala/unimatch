
window.current_notifs = {}

$.fn.addNotifications = (notifications) ->
    window.current_notifs = {}
    $(".notifications-link").click (event)->
        event.preventDefault()
        $(".notifications").toggle()
    
    for i in [0...notifications.length]
        this.addNotification(notifications[i])
    
    return
        
$.fn.addNotification = (notification) ->
    classes = 'notification '
    
    #console.log(notification)
    #console.log(notification['seen'])
    
    if notification['seen']
        classes += 'seen'
    else
        classes += 'unseen'
    
    console.log(notification)
    
    toAppend = ''
    toAppend += '<div class="' + classes + '" conversation_id="' + notification['con_id'] + '">'
    toAppend += '<a href="' + notification['link'] + '">'
    toAppend += '<div class="notification-wrapper">'
    
    toAppend += '<p class="information">' + notification['information'] + '</p>'
    
    toAppend += '</div>'
    toAppend += '</a>'
    toAppend += '</div>'
    $toAppend = $(toAppend)
    this.prepend(toAppend)
    
    return $toAppend
        
#<% @notifs.each do |notif| %>
#    <% classes = "notification " %>
#    <% classes += notif.seen ? "seen" : "unseen" %>
#    
#    <a href="<%= notif.link %>">
#        <div class="<%= classes %>">
#            <p class="information"><%= notif.information %></p>
#        </div>
#    </a>
#<% end %>

