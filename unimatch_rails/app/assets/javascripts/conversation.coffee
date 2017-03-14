#scroll to bottom of messages

$ ->
    window.scrollMessages()
    return

window.scrollMessages = () ->
    $('.messages').scrollTop($('.messages').prop("scrollHeight"));
  
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
