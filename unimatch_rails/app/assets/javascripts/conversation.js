/* global $ */

var LAST_MESSAGE_TIME = null
var loadMore = false
var scrollOnReceive = false

//for loading old crap
var currentMessage = 0
var messagePortion = 10

$.fn.messages = function(con_id){
    this.append('<div class="messages-container"></div>')
    
    var messageField = ''
    messageField += '<div class="write-message">'
    messageField += '<p>Message <textarea class="message-body" /> </p>'
    messageField += '<p><input type="submit" id="send-message" value="send" /></p>'
    messageField += '</div>'
    this.append(messageField)
    
    $('#send-message').click(function(e) {
        e.preventDefault();
        
        var msg = $(".write-message .message-body").val();
        sendMessage('/conversation/create_message', msg, con_id);
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
                
                if (LAST_MESSAGE_TIME == null && i+1 == data.length) {
                    LAST_MESSAGE_TIME = msg.created_at
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
    var toAppend = '';
    toAppend += '<div class="message">'
    toAppend += '<p>'
    toAppend += data.sender + ' ' 
    toAppend += data.date
    toAppend += '</p>'
    
    toAppend += '<p>'
    toAppend += data.body
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

//the code beneath was not rewritten into coffe files, it needs to be in the view
//it uses LAST_MESSAGE_TIME from ruby
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

function render_messages(messages) {
    messages.reverse()
    
    //var lastTime = LAST_MESSAGE_TIME;
    
    for (var i = 0; i < messages.length; i++) {
        var message = messages[i];
        
        var date = new Date(message.created_at);
        
        //if (date.getTime() > LAST_MESSAGE_TIME) {
           //lastTime = date.getTime();
           
           //$(".messages").append(
            //   "<p>FROM: " + users[message.sender_id]['name'] + " AT: " + message['created_at'] + "</p>" +
             //  "<p>" + message.body + "</p><br/><br/>"
            //);
        //}
        LAST_MESSAGE_TIME = lastTime;
    }
    scrollMessages()
}