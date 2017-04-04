/* global $ */

$(document).ready(function() {
    //star
    $(".star").click(function(e) {
        var star = this
        switch_favourite($(star).attr("user_id"))
        
        if ($(star).hasClass("star-active")) {
            $(star).removeClass("star-active");
            $(star).addClass("star-inactive");
        } else {
            $(star).removeClass("star-inactive");
            $(star).addClass("star-active");
        }
    })
    
    //hover on mini-userbox
    $(".user-mini-container .user-mini-element").mouseenter(function() {
        $(this).find(".special-action").show();
    })
    
    $(".user-mini-container .user-mini-element").mouseleave(function() {
        $(this).find(".special-action").hide();
    })
});

function switch_favourite(user_id) {
	$.ajax({
		type: 'POST',
		url: '/user/switch_favourite',
		dataType: "json",
		data: {
		  user_id: user_id
		},
		success: function() {   
		    
		    
		    
		},
        error: function(xhr, ajaxOptions, thrownError) {
            alert(xhr.status)
            alert(xhr.statusText)
            alert(xhr.responseText)	
        }
	});
}