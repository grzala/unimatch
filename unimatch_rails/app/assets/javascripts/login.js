//= require jquery
//= require jquery_ujs
//= require turbolinks

function show_login(e=false) {
	 	$("#register_form").hide();
		$("#login_form").fadeIn(100);
	 	$('#register_text').removeClass('active');
		$('#login_text').addClass('active');
		if(e){e.preventDefault();}
	}
	
function show_register(e=false) {
 		$("#login_form").hide();
		$("#register_form").fadeIn(100);
 		$('#login_text').removeClass('active');
		$('#register_text').addClass('active');
		if(e){e.preventDefault();}
		
	}


$(document).on('ready turbolinks:load',function(){
	setTimeout(function(){
		if(window.location.hash == "#register") show_register();
		else if(window.location.hash == "#login") show_login();	
	}, 0)
	
})
	
	
$(document).on('turbolinks:load', function() {

$(function() {

	    $('#login_title').click(function(e){
	    	show_login(e);
		});
	
	    $('#register_title').click(function(e){
			show_register(e);
		});

});

});