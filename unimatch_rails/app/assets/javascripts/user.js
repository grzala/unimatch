/* global $ */

$(document).ready(function() {
    $(".star").click(function(e) {
        var star = this
        switch_favourite($(star).attr("user_id"))
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