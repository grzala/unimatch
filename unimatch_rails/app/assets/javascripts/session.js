$(document).on('turbolinks:load', function() {
    
   $(function() {

    $('#login_link').click(function(e) {
		$("#login_form").delay(50).fadeIn(50);
 		$("#register_form").fadeOut(50);
		$('#register_link').removeClass('active');
		$(this).addClass('active');
		e.preventDefault();
	});
	$('#register_link').click(function(e) {
		$("#register-form").delay(50).fadeIn(50);
 		$("#login_form").fadeOut(50);
		$('#login_link').removeClass('active');
		$(this).addClass('active');
		e.preventDefault();
	});

});

});
