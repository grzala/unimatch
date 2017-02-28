jQuery(document).on 'turbolinks:load', ->
    App.conversation = App.cable.subscriptions.create {
            channel: "ConversationChannel", 
            conversation_room_id: CON_ID,
        },
        connected: -> 
            # Called when the subscription is ready for use on the server 
        disconnected: -> 
            # Called when the subscription has been terminated by the server
        received: (data) -> 
            # Called when there's incoming data on the websocket for this channel
        message: (conversation_room_id, body)-> 
            @perform 'message', conversation_room_id: conversation_room_id
            
        received: (data) -> 
            if parseInt(data["conversation_room_id"]) == CON_ID
                reload_messages(data["conversation_room_id"])
        
    