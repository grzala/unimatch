/* global $ */

var LAST_MESSAGE_TIME = null

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
    
    requestMessages(0, 10, con_id);
    
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
		    console.log("requesting")
		    for (var i = 0; i < data.length; i++) {
		        var msg = makeMessage(data[i]);
                $('.messages .messages-container').prepend(msg);
                if (LAST_MESSAGE_TIME == null && i+1 == data.length) {
                    LAST_MESSAGE_TIME = msg.created_at
                }
            }
            
            
            
            scrollMessages();
            //loadMore = true;
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

//scroll to bottom of messages
$(document).ready(function() {
    scrollMessages();
    return;
});

  
function sendMessage(url, msg, con_id) {
    $.ajax({
		type: 'POST',
		url: url,
        data: {
            conversation_id: con_id,
            body: msg
        },
        success: function() { 
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
		    
		    console.log("-----------------------------")
		    
		    var lastTime = LAST_MESSAGE_TIME;
		    for (var i = 0; i < data.length; i++) {
                $('.messages .messages-container').append(makeMessage(data[i]));
                var date = new Date(data[i].date);
                console.log("LAST TIME" + lastTime);
                console.log("current" + date.getTime());
                console.log("")
        
                if (date.getTime() > LAST_MESSAGE_TIME) {
                   lastTime = date.getTime();
                }
            }
           LAST_MESSAGE_TIME = lastTime;
            scrollMessages();
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