/* global $ */

var LAST_MESSAGE_TIME = null
var loadMore = false
var scrollOnReceive = false

//for loading old crap
var currentMessage = 0
var messagePortion = 10

$.fn.messages = function(con_id){
    curentMessage = 0;
    this.empty();
    this.append('<div class="messages-container"></div>')
    
    var messageField = ''
    // messageField += '<div class="write-message">'
    messageField += '<textarea class="message-body" placeholder="Write a reply... press enter to send"></textarea>'
    // messageField += '<p><input type="submit" id="send-message" value="send" /></p>'
    // messageField += '</div>'
    this.append(messageField)
    
    $('#send-message').click(function(e) {
        e.preventDefault();
        
        var msg = $(".write-message .message-body").val();
        $(".write-message .message-body").val('')
        
        sendMessage('/conversation/create_message', msg, con_id);
    });
    $(document).keypress(function(e) {
        if(e.which == 13) {
            e.preventDefault();
            
            var messageBody = $('.write-message .message-body')
            if (messageBody.is(":focus")) {
                var msg = $(".write-message .message-body").val();
                $(".write-message .message-body").val('')
                
                sendMessage('/conversation/create_message', msg, con_id);
            }
        }
    });
    
    requestMessages(currentMessage, currentMessage + messagePortion, con_id);
    
    
    //scroll listener
    scrollMessages();
    var messageBox = $(this).find(".messages-container")
    messageBox.scroll(function() {
        if (loadMore && messageBox.scrollTop() <= 20) {
            requestMessages(currentMessage, currentMessage + messagePortion, con_id)
            loadMore = false
        }
    });
    
}

function requestMessages(from, to, con_id) {
	$.ajax({
		type: 'POST',
		url: '/message',
		dataType: "json",
		data: {
		  from: from,
		  to: to,
		  id: con_id
		},
		success: function(data) {    
            var messageBox = $(".messages .messages-container")
            var initialHeight = messageBox.prop("scrollHeight")
            
		    for (var i = 0; i < data.length; i++) {
		        var msg = makeMessage(data[i]);
                $('.messages .messages-container').prepend(msg);
                currentMessage++
                if (LAST_MESSAGE_TIME == null && i+1 == data.length) { //last message, new time, call only on init
                    var time = new Date(data[i].date)
                    LAST_MESSAGE_TIME = time.getTime();
                }
            }
            var endHeight = messageBox.prop("scrollHeight")
            if (endHeight - initialHeight > 0)
                messageBox.scrollTop(endHeight - initialHeight) //Scroll the amount of messages added
            
            loadMore = true;
		},
        error: function(xhr, ajaxOptions, thrownError) {
            alert(xhr.status)
            alert(xhr.statusText)
            alert(xhr.responseText)	
        }
	});
}

function makeMessage(data) {
    clas = data['own'] ? "message-sent" : "message-received";
    
    var toAppend = '';
    toAppend += '<div class="message ' + clas + '">'
    
    if (clas == 0) {
        toAppend += '<div id="empty_convo"><h3>Start your conversation here</h3></div>'
    }
        
    
    if (!data['own']) {
        toAppend += '<img src="' + data.img + '" class="message_pic">'
    }

    toAppend += '<p class="message_text">'
    toAppend += data.body
    toAppend += '</p>'
    
    toAppend += '<p class="message_date">'
    
    toAppend += moment(data.date).format("ddd h:ma, Do MMM YYYY");
    toAppend += '</p>'
    
    toAppend += '</div>'
    
    return toAppend
}

function scrollMessages() {
    $('.messages-container').scrollTop($('.messages-container').prop("scrollHeight"));
}

  
function sendMessage(url, msg, con_id) {
    $.ajax({
		type: 'POST',
		url: url,
        data: {
            conversation_id: con_id,
            body: msg
        },
        success: function() { 
            if ($('.messages .messages-container').scrollTop() + $('.messages .messages-container').innerHeight() >= $('.messages .messages-container').prop("scrollHeight") - 30) 
                scrollOnReceive = true;
            
            App.conversation.message(con_id, msg)
        },
        
        error: function(xhr, ajaxOptions, thrownError) {
            alert(xhr.status)
            alert(xhr.statusText)
            alert(xhr.responseText)	
        }
	});
}

function reloadMessages(id) {
    var url = "/conversation/" + id;
    
	$.ajax({
		type: 'POST',
		url: '/message',
		dataType: "json",
		data: {
		  last: LAST_MESSAGE_TIME,
		  id: id
		},
		success: function(data) {
		    data.reverse()
		    
		    var lastTime = LAST_MESSAGE_TIME;
		    for (var i = 0; i < data.length; i++) {
                var date = new Date(data[i].date);
        
                //Date is compared in SQL Query. Query does not have milliseconcs accuracy, so it is double checked here.
                //Fail to do it and you will add copies of the same message a few times.
                if (date.getTime() > LAST_MESSAGE_TIME) {
                    $('.messages .messages-container').append(makeMessage(data[i]));
                    currentMessage++
                    lastTime = date.getTime();
                }
            }
            LAST_MESSAGE_TIME = lastTime;
            
            if (scrollOnReceive) {
                scrollMessages()
                scrollOnReceive = false
            }
		},
        error: function(xhr, ajaxOptions, thrownError) {
            alert(xhr.status)
            alert(xhr.statusText)
            alert(xhr.responseText)	
        }
	});
	
}
