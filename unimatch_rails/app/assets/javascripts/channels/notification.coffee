jQuery(document).on 'turbolinks:load', ->
  App.notification = App.cable.subscriptions.create "NotificationChannel",
    connected: ->
      # Called when the subscription is ready for use on the server
    
    disconnected: ->
      # Called when the subscription has been terminated by the server
    
    notify: (text) ->
      @perform 'notify'
    
    received: (data) ->
      #no need to do anythying, check conversation.coffee