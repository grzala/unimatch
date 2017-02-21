//= require jquery
//= require jquery_ujs
//= require turbolinks

$(document).on('turbolinks:load', function() {

    
   $(function() {

    $('#login_title').click(function(e) {
 		$("#register_form").hide();
		$("#login_form").fadeIn(100);
 		$('#register_text').removeClass('active');
		$('#login_text').addClass('active');
		e.preventDefault();
	});
	$('#register_title').click(function(e) {
 		$("#login_form").hide();
		$("#register_form").fadeIn(100);
 		$('#login_text').removeClass('active');
		$('#register_text').addClass('active');
		e.preventDefault();
	});

});

});