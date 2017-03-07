
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
    #remove duplicates
    #we want just one notification for a given conversation
    children = $(this).children(".notification")
    for i in [0...children.length]
        #if already notified
        if parseInt($(children[i]).attr("conversation_id")) == parseInt(notification['conversation_id'])
            $(children[i]).remove()
    classes = 'notification '
    
    if notification['seen']
        classes += 'seen'
    else
        classes += 'unseen'
    
    toAppend = ''
    toAppend += '<div class="' + classes + '" conversation_id="' + notification['conversation_id'] + '">'
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

