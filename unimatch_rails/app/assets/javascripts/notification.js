/* global $ */

var loadMore = false

$.fn.addNotifications = function(notifications) {
    this.empty();
    loadMore = false
    
    requestNotifications();
    
    window.current_notifs = {};
    $(".notifications-link").click(function(event) {
        event.preventDefault();
        $(".notifications").toggle();
    });

        
    this.append("<div><p>LOADING ICON </p></div>");
    
    this.scrollNotifs();
    
    this.scroll(function() {
        if (loadMore && $(this).scrollTop() + $(this).innerHeight() >= $(this).prop("scrollHeight" ) - 30) {
            console.log("load more");
            loadMore = false;
        }
    });

    
    return;
};

function makeNotif(notification) {
    //remove duplicates
    //we want just one notification for a given conversation
    var children = $(this).children(".notification");
    for (var i = 0; i < children.length; i++) {
        //if already notified
        if (parseInt($(children[i]).attr("conversation_id"), 10) == parseInt(notification['conversation_id'], 10)) {
            $(children[i]).remove();
        }
    }
    var classes = 'notification ';
    
    if (notification['seen']) {
        classes += 'seen';
    } else {
        classes += 'unseen';
    }
    
    var toAppend = '';
    toAppend += '<div class="' + classes + '" conversation_id="' + notification['conversation_id'] + '">';
    toAppend += '<a href="' + notification['link'] + '">';
    toAppend += '<div class="notification-wrapper">';
    
    toAppend += '<p class="information">' + notification['information'] + '</p>';
    
    toAppend += '</div>';
    toAppend += '</a>';
    toAppend += '</div>';
    var $toAppend = $(toAppend);
    
    return $toAppend;
    
}

$.fn.scrollNotifs = function() {
    this.scrollTop(0);
};

function requestNotifications() {
	$.ajax({
		type: 'POST',
		url: '/notification',
		dataType: "json",
		data: {
		  from: 0,
		  to: 10,
		},
		success: function(data) {    
		    for (var i = 0; i < data.length; i++) {
                $('.notifications').prepend(makeNotif(data[i]));
            }
            loadMore = true;
		}
	});
}