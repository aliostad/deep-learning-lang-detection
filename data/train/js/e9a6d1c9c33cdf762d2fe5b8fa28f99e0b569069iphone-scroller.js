$(document).ready(function()
{
	
	// First time, the indicator needs a character
	$("#nav-indicator-fixed").append("A");
	
	// Fading out the search bar
	$("#iphone-search").fadeTo(1, 0.85);
	
	// Append background when search bar is hovered
	$("#iphone-search").hover(function()
	{
		$("#iphone-search").addClass("searchbg");
	},function()
	{
		$("#iphone-search").removeClass("searchbg");
	});
	
	// When scrolling, this function checks if the indicator needs to be changed
	var curb = $("#nav-b").position().top;
	var curc = $("#nav-c").position().top;
	var curd = $("#nav-d").position().top;
	var cure = $("#nav-e").position().top;
	var curf = $("#nav-f").position().top;
	var curg = $("#nav-g").position().top;
	var curi = $("#nav-i").position().top;
	
	var changeNavIndicator = function(value)
	{
		$("#nav-indicator-fixed").replaceWith("<div id=\"nav-indicator-fixed\">"+value+"</div>");
	}
	
	$("#iphone-scrollcontainer").scroll(function()
	{
		if($("#nav-a").position().top < 20 && $("#nav-a").position().top > -20)
			changeNavIndicator("A");
		
		if($("#nav-b").position().top < 20 && $("#nav-b").position().top > -20)
		{
			if(curb < $("#nav-b").position().top)
				changeNavIndicator("A");
			else
				changeNavIndicator("B");;
			curb = $("#nav-b").position().top;
		}
		if($("#nav-c").position().top < 20 && $("#nav-c").position().top > -20)
		{
			if(curc < $("#nav-c").position().top)
				changeNavIndicator("B");
			else
				changeNavIndicator("C");;
			curc = $("#nav-c").position().top;
		}
		if($("#nav-d").position().top < 20 && $("#nav-d").position().top > -20)
		{
			if(curd < $("#nav-d").position().top)
				changeNavIndicator("C");
			else
				changeNavIndicator("D");
			curd = $("#nav-d").position().top;
		}
		if($("#nav-e").position().top < 20 && $("#nav-e").position().top > -20)
		{
			if(cure < $("#nav-e").position().top)
				changeNavIndicator("D");
			else
				changeNavIndicator("E");
			cure = $("#nav-e").position().top;
		}
		if($("#nav-f").position().top < 20 && $("#nav-f").position().top > -20)
		{
			if(curf < $("#nav-f").position().top)
				changeNavIndicator("E");
			else
				changeNavIndicator("F");
			curf = $("#nav-f").position().top;
		}
		if($("#nav-g").position().top < 20 && $("#nav-g").position().top > -20)
		{
			if(curg < $("#nav-g").position().top)
				changeNavIndicator("F");
			else
				changeNavIndicator("G");
			curg = $("#nav-g").position().top;
		}
		if($("#nav-i").position().top < 20 && $("#nav-i").position().top > -20)
		{
			if(curi < $("#nav-i").position().top)
				changeNavIndicator("G");
			else
				changeNavIndicator("I");
			curi = $("#nav-i").position().top;
		}
		
		// Fade the indicator, staying CSS2.1 valid
		$("#nav-indicator-fixed").fadeTo(1, 0.85);
	});
});