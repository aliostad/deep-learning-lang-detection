function size_sur_nav_text() {
	var count = $(".sur_nav_text").length;
	var max = 0
	for (var i = 0; i < count; i++) {
		var content = ".sur_nav_text:eq("+ i + ")";
		var content_height = $(content).css("height").replace("px", "");;
		var content_height = parseInt(content_height);
		if ( content_height > max){
			max = content_height;
		}
	};
	$(".sur_nav_text").css("height" , max );
}
function open_close_sur_nav(){
	var isSurNavClick = $(this).hasClass("sur_nav_close");
	if(isSurNavClick){
		$(".sur_nav nav").fadeIn();
		$(this).text("-");
		$(this).toggleClass("sur_nav_close sur_nav_open");
		size_sur_nav_text();
		$(".sur_nav nav").mCustomScrollbar({
			axis:"x" 
		});
	}
	else {
		$(".sur_nav nav").fadeOut();
		$(this).text("+");
		$(this).toggleClass("sur_nav_close sur_nav_open");
	}
	
}
$( document ).ready(function() {
	$(".sur_nav_btn").click(open_close_sur_nav);
});