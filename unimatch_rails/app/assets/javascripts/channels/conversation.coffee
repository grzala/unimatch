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