var nav_p = "vacio";

$(document).on("ready",omega);

function omega(){
    var $nav = $("#nav-fixed");
    $nav.find("a").on("click",animate_scroll)
    var $win 			= $(window);
    var nav_position 	= $nav.offset();
    var win_s 			= $win.scrollTop();

	//$win.on("scroll",        {win:$win,nav:$nav,nav_p:nav_position},fixed_nav)
    
    
}


	
function fixed_nav(event){
    
    if(nav_p == "vacio"){
        var nav_c = $(".nav-container").offset();
        nav_p = nav_c.top;
        console.log(nav_p)
    }
    
	if (event.data.win.scrollTop() >= event.data.nav_p.top){
			event.data.nav.addClass("nav-on");
	}
    else{            	         
		event.data.nav.removeClass("nav-on");
    }	
}

//Necesitamos tres variables 
    //la altura del nav
    //Nuestro objetivo 
    //la posición de objetivo

function animate_scroll(event){
    event.preventDefault();
	var $this = $(this)	
	var nav_alt = $this.closest("nav").height()
	var scroll_target = $this.attr("href");
    var scroll_direccion = $("#"+scroll_target).offset().top;	
    $("html:not(:animated),body:not(:animated)").animate({ scrollTop: scroll_direccion}, 500 );
}
