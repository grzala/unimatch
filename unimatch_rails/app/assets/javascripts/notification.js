/* global $ */

var loadMore = false;
var current_notif = 0;
var NOTIF_SET = 10;

$.fn.notificationsLink = function() {
    //this.empty();
    //link
    this.append('<div class="new-notif-length"></div>')
    $(".notifications-link").click(function(event) {
        //event.preventDefault();
        $(".notifications").toggle();
        //$(".notifications").css("left", event.pageX - $(".notifications").width());
        //$(".notifications").css("top", event.pageY);
    });
}

function refreshNotifLen() {
    var active_notifs = 0
    
    var children = $('.notifications').find('.notifications-wrapper').children(".notification");
    for (var i = 0; i < children.length; i++) {
        if ($(children[i]).hasClass("unseen")) {
            active_notifs += 1
        }
    }
    
    if (active_notifs > 0) {
        $('.new-notif-length').text(active_notifs)
        $('.new-notif-length').show()
    } else {
        $('.new-notif-length').text("")
        $('.new-notif-length').hide()
    }
    $('.new-notif-length').text((active_notifs > 0 ? active_notifs : ""))
}

$.fn.addNotifications = function(notifications) {
    //prepare
    current_notif = 0
    this.empty();
    loadMore = false;
    
    //get notifications by ajax
    this.append('<div class="notifications-wrapper"></div>');
    requestNotifications(current_notif, current_notif + NOTIF_SET);
    
    //hide
    $(document).mouseup(function(event) {
        var container = $(".notifications");
    
        if (( !container.is(event.target)) && container.has(event.target).length === 0) {
            container.hide();
        }
    });
        
    
    //scroll listener
    this.scroll(function() {
        if (loadMore && $(this).scrollTop() + $(this).innerHeight() >= $(this).prop("scrollHeight") - 30) {
            requestNotifications(current_notif, current_notif + NOTIF_SET);
            loadMore = false;
        }
    });

    //scroll to top
    this.scrollNotifs();
    
    refreshNotifLen();
    
    return;
};

$.fn.addNotification = function(notification) {
    var n = makeNotif(notification);
    this.find('.notifications-wrapper').prepend(n);
    current_notif++;
    refreshNotifLen();
}

function makeNotif(notification) {
    //remove duplicates
    //we want just one notification for a given conversation
    var children = $('.notifications').find('.notifications-wrapper').children(".notification");
    for (var i = 0; i < children.length; i++) {
        //if already notified
        if (parseInt($(children[i]).attr("conversation_id"), 10) == parseInt(notification['conversation_id'], 10)) {
            
            $(children[i]).remove();
        }
    }
    var classes = 'notification ';
    
    //if seen
    if (notification['seen']) {
        classes += 'seen';
    } else {
        classes += 'unseen';
    }
    
    var toAppend = '';
    toAppend += '<div class="' + classes + '" conversation_id="' + notification['conversation_id'] + '">';
    toAppend += '<a href="' + notification['link'] + '">';
    toAppend += '<div class="notification-wrapper">';
    
    ///////////////////////////////
    toAppend += '<div class="notif-thumbnail"><img src ="' + notification['image_url'] + '" /></div>';
    toAppend += '<div class="notif-info">'
    toAppend += '<p>' + notification['sender'] + '</p>';
    toAppend += '<p>' + notification['information'] + '</p>';
    toAppend += '</div>'
    ///////////////////////////////
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
		    if (data.length <= 0) {
		        $('.notifications .notifications-wrapper').append('<p>No new notifications</p>');
		        return;
		    }
		    
		    for (var i = 0; i < data.length; i++) {
                $('.notifications .notifications-wrapper').append(makeNotif(data[i]));
                current_notif++;
            }
            
            loadMore = true;
            refreshNotifLen();
		},
        error: function(xhr, ajaxOptions, thrownError) {
            alert(xhr.status)
            alert(xhr.statusText)
            alert(xhr.responseText)	
        }
	});
}