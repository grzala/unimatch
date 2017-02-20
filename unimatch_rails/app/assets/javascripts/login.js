//= require jquery
//= require jquery_ujs
//= require turbolinks

$(document).on('turbolinks:load', function() {

    
   $(function() {

    $('#login_title').click(function(e) {
		$("#login_form").delay(99).fadeIn(100);
 		$("#register_form").fadeOut(100);
 		$('#register_text').removeClass('active');
		$('#login_text').addClass('active');
		e.preventDefault();
	});
	$('#register_title').click(function(e) {
		$("#register_form").delay(99).fadeIn(100);
 		$("#login_form").fadeOut(100);
 		$('#login_text').removeClass('active');
		$('#register_text').addClass('active');
		e.preventDefault();
	});

});

});