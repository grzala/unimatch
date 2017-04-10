/* global $ */

function initFavs() {
    console.log("Star ready");
    //star
    $("#change_fav").click(function(e) {
        e.preventDefault();
        console.log("click");
        var btn = this;
        switch_favourite($(btn).attr("user_id"));
        
        var span = $(btn).find("span");
        
        console.log($(span).hasClass("fav"));
        if ($(span).hasClass("fav")) {
            $(span).text("Add to favourites");
            $(span).removeClass("fav");
            $(span).addClass("non-fav");
        } else {
            $(span).text("Remove from favourites");
            $(span).removeClass("non-fav");
            $(span).addClass("fav");
        }

    })
}

function initUserMini() {
    //hover on mini-userbox
    $(".user-mini-container .user-mini-element").mouseenter(function() {
        console.log("enter");
        $(this).find(".special-action").show();
    })
    
    $(".user-mini-container .user-mini-element").mouseleave(function() {
        $(this).find(".special-action").hide();
    })
}

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