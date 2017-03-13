/* global $ */


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
		    console.log(data)
		    for (var i = 0; i < data.length; i++) {
                $('.messages .messages-container').append(makeMessage(data[i]));
            }
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
    $('.messages').scrollTop($('.messages').prop("scrollHeight"));
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
