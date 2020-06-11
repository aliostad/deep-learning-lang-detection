//Remove home page links
$(".home-page-only").css('visibility', 'hidden');

//Box stuff
$( "#show-front" ).on( "click", function () {
	$("#cube").attr("class", "show-front");
});

$( "#show-back" ).on( "click", function () {
	$("#cube").attr("class", "show-back");
});

$( "#show-right" ).on( "click", function () {
	$("#cube").attr("class", "show-right");
});

$( "#show-left" ).on( "click", function () {
	$("#cube").attr("class", "show-left");
});

$( "#show-top" ).on( "click", function () {
	$("#cube").attr("class", "show-top");
});

$( "#show-bottom" ).on( "click", function () {
	$("#cube").attr("class", "show-bottom");
});