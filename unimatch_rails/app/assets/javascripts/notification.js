/* global $ */

var loadMore = false;
var current_notif = 0;
var NOTIF_SET = 10;

$.fn.addNotifications = function(notifications) {
    //prepare
    this.empty();
    loadMore = false;
    
    //get notifications by ajax
    this.append('<div class="notifications-wrapper"></div>');
    requestNotifications(current_notif, current_notif + NOTIF_SET);
    current_notif += NOTIF_SET;
    
    //link
    $(".notifications-link").click(function(event) {
        event.preventDefault();
        $(".notifications").toggle();
        $(".notifications").css("left", event.pageX - $(".notifications").width());
        $(".notifications").css("top", event.pageY);
    });
    
    //hide
    $(document).mouseup(function(event) {
        var container = $(".notifications");
    
        if (!container.is(event.target) && container.has(event.target).length === 0) {
            container.hide();
        }
    });
        
    //loading icon
    this.append('<div><img class="loading-icon" src="/assets/loading.png" /></div>');
    
    //scroll listener
    this.scroll(function() {
        if (loadMore && $(this).scrollTop() + $(this).innerHeight() >= $(this).prop("scrollHeight") - 30) {
            console.log("load more");
            requestNotifications(current_notif, NOTIF_SET);
            current_notif += NOTIF_SET;
            loadMore = false;
        }
    });

    //scroll to top
    this.scrollNotifs();
    
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

function requestNotifications(from, to) {
	$.ajax({
		type: 'POST',
		url: '/notification',
		dataType: "json",
		data: {
		  from: from,
		  to: to,
		},
		success: function(data) {    
		    for (var i = 0; i < data.length; i++) {
                $('.notifications .notifications-wrapper').append(makeNotif(data[i]));
            }
            loadMore = true;
		}
	});
}