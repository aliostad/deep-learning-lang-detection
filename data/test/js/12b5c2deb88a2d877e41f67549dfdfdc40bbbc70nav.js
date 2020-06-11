function startIt(){

	var menu = $(".menu");
	var navContainer = $(".nav-container");

	function sideNav(){
		navContainer.removeClass( "nav-container__full" ).addClass( "nav-container__side" );

	}

	function hideNav(){
		var w = window.innerWidth;
		if (w < 900) {
			navContainer.toggleClass( "nav-hidden-left" );
			menu.toggleClass( "hidden" );
		} else {
			navContainer.addClass( "nav-hidden-left" );
			menu.removeClass( "hidden" );
		}
		
	}
	
	function menuText(){
		if (menu.text() == "X") {
			menu.text("Menu");
		} else {
			menu.text("X");
		}
	}

	menu.click(function(){
		hideNav();
		sideNav();
	});

	var navLink = $(".nav-link");
	navLink.on("click", function(e){
		hideNav();
	})

}

document.addEventListener("DOMContentLoaded", function(event) { 
  startIt();
});

