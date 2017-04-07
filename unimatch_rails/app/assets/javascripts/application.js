// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.qtip
//= require turbolinks
//= require bootstrap
//= require bootstrap-sprockets
//= require moment.min
//= require moment
//= require fullcalendar/fullcalendar
//= require cable
//= require_tree .


$(document).on('turbolinks:load', function() {
    
    $("#startdate").datepicker({ dateFormat: 'd MM yy' });
    $("#enddate").datepicker({ dateFormat: 'd MM yy' });
    
    /*
    $("#burger_menu").click(function(){
        $("#container").toggleClass("container_show")});
        
    $("#nav_trigger").click(function(){
    console.log("nav trigger clicked");
    $("#navigation_mobile_container").toggleClass("on");
    
    });
    */
    
    /* Set the width of the side navigation to 250px and the left margin of the page content to 250px and add a black background color to body */
    $("#nav_trigger").click(function(){
        document.getElementById("mySidenav").style.width = "250px";
    });

    /* Set the width of the side navigation to 0 and the left margin of the page content to 0, and the background color of body to white */
    $("#closebtn").click(function(){
        document.getElementById("mySidenav").style.width = "0";
    });

});






