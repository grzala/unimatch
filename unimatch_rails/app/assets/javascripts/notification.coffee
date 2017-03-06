$.fn.addNotifications = (notifications) ->
    $(".notifications-link").click (event)->
        event.preventDefault()
        $(".notifications").toggle()
    
    for i in [0...notifications.length]
        addNotification(this, notifications[i])
        
addNotification = (div, notification) ->
    classes = 'notification '
    console.log(notification['seen'])
    if notification['seen']
        classes += 'seen'
    else
        classes += 'unseen'
    
    toAppend = ''
    toAppend += '<a href="' + notification['link'] + '">'
    toAppend += '<div class="' + classes + '">'
    
    toAppend += '<p class="information">' + notification['information'] + '</p>'
    
    toAppend += '</div>'
    toAppend += '</a>'
    div.append(toAppend)
    
    
    return
        
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

