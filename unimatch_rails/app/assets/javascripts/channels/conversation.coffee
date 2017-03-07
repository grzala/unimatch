jQuery(document).on 'turbolinks:load', ->
    App.conversation = App.cable.subscriptions.create "ConversationChannel",
    
        connected: -> 
            # Called when the subscription is ready for use on the server 
        disconnected: -> 
            # Called when the subscription has been terminated by the server
        received: (data) -> 
            # Called when there's incoming data on the websocket for this channel
        message: (conversation_id, body)-> 
            @perform 'message', conversation_id: conversation_id
            
        received: (data) -> 
            if CON_ID? and parseInt(data["conversation_id"]) == CON_ID
                reloadMessages(data["conversation_id"])
        
window.sendMessage = (url, msg, con_id) ->
    $.ajax url,
        type: "POST",
        data: {
            conversation_id: con_id
            body: msg
        },
        success: () ->
            App.conversation.message(con_id, msg)
        
        error: (xhr, ajaxOptions, thrownError) ->
            alert(xhr.status)
            alert(xhr.statusText)
            alert(xhr.responseText)
