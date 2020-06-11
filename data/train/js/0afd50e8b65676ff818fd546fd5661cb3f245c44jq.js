//Javascript 
$(document).ready(function() {
$("#schedule").click(function(){if( $("#schedule_nav").is(':hidden')) {$("#employees_nav, #reports_nav").hide();$("#schedule_nav").show();}else {$("#schedule_nav").hide();}});
$("#employees").click(function(){if( $("#employees_nav").is(':hidden')) {$("#schedule_nav, #reports_nav").hide();$("#employees_nav").show();}else {$("#employees_nav").hide();}});
$("#reports").click(function(){if( $("#reports_nav").is(':hidden')) {$("#schedule_nav, #employees_nav").hide();$("#reports_nav").show();}else {$("#reports_nav").hide();}});

});
