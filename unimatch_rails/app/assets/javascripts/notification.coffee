$(document).ready ->
    $(".notifications-link").click (event)->
        event.preventDefault()
        $(".notifications").toggle()