#scroll to bottom of messages

$ ->
    window.scrollMessages()
    return

window.scrollMessages = () ->
    $('.messages').scrollTop($('.messages').prop("scrollHeight"));
