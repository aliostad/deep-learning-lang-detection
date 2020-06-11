jQuery.defaultSideMenu = function(tabno){
	$("nav#vertical-nav ul.nav  li").removeClass("active");
	$("nav#vertical-nav ul.nav  li i").removeClass("icon-white");
	$('nav#vertical-nav ul.nav li:nth-child('+tabno+')').addClass("active");
	$('nav#vertical-nav ul.nav li:nth-child('+tabno+') i').addClass("icon-white");

};

jQuery.defaultHorizontalNav = function(tabno){
	$("nav#horizontal-nav ul.nav  li").removeClass("active");
	$('nav#horizontal-nav ul.nav li:nth-child('+tabno+')').addClass("active");
};

jQuery.scrollToTag=function(param){	
	var parameter = param.split("=");
		var aTag
			if (parameter[0]=='class'){
				 aTag = $("."+parameter[1])
				}	else{ 
					aTag = $("#"+parameter[1]);	
				}	 
				$('html,body').animate({scrollTop: aTag.offset().top},'slow');
			} 