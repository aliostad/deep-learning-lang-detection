var v_nav = {
	"navi": null,
	"height": null,
	"width": null,
	"test": null,
};

var nav  = {
	v_init: function(){
		v_nav.navi = $("nav");
		v_nav.height = v_nav.navi.height();
		v_nav.width = v_nav.navi.width();
	},
	init: function(){ 
		nav.v_init();
		v_nav.navi.css('left',-v_nav.width*0.95);
	},
	move: function(){
		
	},
};


$(document).ready(function (){
	nav.init();
});

$(document).resize(function (){
	nav.init();
});

$("nav").click(function(){
	v_nav.test = false;
	v_nav.navi.animate({left: "0"},300); 	
});

$("nav").mouseleave(function(){
   v_nav.test = true;
   v_nav.navi.animate({left: -v_nav.width*0.95},300);  
});
