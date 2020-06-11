
//script for i-phone scroller
<script type="text/javascript" src="js/libs/iphone-scroller.js"></script>

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
	var curb = $("#nav-B").position().top;
	var curc = $("#nav-C").position().top;
	var curd = $("#nav-D").position().top;
	var cure = $("#nav-D").position().top;
	var curf = $("#nav-F").position().top;
	var curg = $("#nav-G").position().top;
	var curh = $("#nav-H").position().top;
	var curi = $("#nav-I").position().top;
	var curj = $("#nav-J").position().top;
	var curk = $("#nav-K").position().top;
	var curl = $("#nav-L").position().top;
	var curm = $("#nav-M").position().top;
	var curn = $("#nav-N").position().top;
	var curo = $("#nav-O").position().top;
	var curp = $("#nav-P").position().top;
	var curq = $("#nav-Q").position().top;
	var curr = $("#nav-R").position().top;
	var curs = $("#nav-S").position().top;
	var curt = $("#nav-T").position().top;
	var curu = $("#nav-U").position().top;
	var curv = $("#nav-V").position().top;
	var curw = $("#nav-W").position().top;
	var curx = $("#nav-X").position().top;
	var cury = $("#nav-Y").position().top;
	var curz = $("#nav-Z").position().top;

	var changeNavIndicator = function(value)
	{
		$("#nav-indicator-fixed").replaceWith("<div id=\"nav-indicator-fixed\">"+value+"</div>");
	}
	
	$("#iphone-scrollcontainer").scroll(function()
	{
		if($("#nav-A").position().top < 20 && $("#nav-A").position().top > -20)
			changeNavIndicator("A");
		
		if($("#nav-B").position().top < 20 && $("#nav-B").position().top > -20)
		{
			if(curb < $("#nav-B").position().top)
				changeNavIndicator("A");
			else
				changeNavIndicator("B");;
			curb = $("#nav-B").position().top;
		}
		if($("#nav-C").position().top < 20 && $("#nav-C").position().top > -20)
		{
			if(curc < $("#nav-C").position().top)
				changeNavIndicator("B");
			else
				changeNavIndicator("C");;
			curc = $("#nav-C").position().top;
		}
		if($("#nav-D").position().top < 20 && $("#nav-D").position().top > -20)
		{
			if(curd < $("#nav-D").position().top)
				changeNavIndicator("C");
			else
				changeNavIndicator("D");
			curd = $("#nav-D").position().top;
		}
		if($("#nav-E").position().top < 20 && $("#nav-E").position().top > -20)
		{
			if(cure < $("#nav-E").position().top)
				changeNavIndicator("D");
			else
				changeNavIndicator("E");
			cure = $("#nav-E").position().top;
		}
		if($("#nav-F").position().top < 20 && $("#nav-F").position().top > -20)
		{
			if(curf < $("#nav-F").position().top)
				changeNavIndicator("E");
			else
				changeNavIndicator("F");
			curf = $("#nav-F").position().top;
		}
		if($("#nav-G").position().top < 20 && $("#nav-G").position().top > -20)
		{
			if(curg < $("#nav-G").position().top)
				changeNavIndicator("F");
			else
				changeNavIndicator("G");
			curg = $("#nav-G").position().top;
		}
		if($("#nav-H").position().top < 20 && $("#nav-H").position().top > -20)
		{
			if(curh < $("#nav-H").position().top)
				changeNavIndicator("G");
			else
				changeNavIndicator("H");
			curh = $("#nav-H").position().top;
		}		
		if($("#nav-I").position().top < 20 && $("#nav-I").position().top > -20)
		{
			if(curi < $("#nav-I").position().top)
				changeNavIndicator("H");
			else
				changeNavIndicator("I");
			curi = $("#nav-I").position().top;
		}	
			if($("#nav-J").position().top < 20 && $("#nav-J").position().top > -20)
		{
			if(curj < $("#nav-J").position().top)
				changeNavIndicator("I");
			else
				changeNavIndicator("J");
			curj = $("#nav-J").position().top;
		}	
		if($("#nav-K").position().top < 20 && $("#nav-K").position().top > -20)
		{
			if(curk < $("#nav-K").position().top)
				changeNavIndicator("J");
			else
				changeNavIndicator("K");
			curk = $("#nav-K").position().top;
		}
		if($("#nav-L").position().top < 20 && $("#nav-L").position().top > -20)
		{
			if(curl < $("#nav-L").position().top)
				changeNavIndicator("K");
			else
				changeNavIndicator("L");
			curl = $("#nav-L").position().top;
		}	
		if($("#nav-M").position().top < 20 && $("#nav-M").position().top > -20)
		{
			if(curm < $("#nav-M").position().top)
				changeNavIndicator("L");
			else
				changeNavIndicator("M");
			curm = $("#nav-M").position().top;
		}	
		if($("#nav-N").position().top < 20 && $("#nav-N").position().top > -20)
		{
			if(curn < $("#nav-N").position().top)
				changeNavIndicator("M");
			else
				changeNavIndicator("N");
			curn = $("#nav-N").position().top;
		}	
		if($("#nav-O").position().top < 20 && $("#nav-O").position().top > -20)
		{
			if(curo < $("#nav-O").position().top)
				changeNavIndicator("N");
			else
				changeNavIndicator("O");
			curo = $("#nav-O").position().top;
		}	
		if($("#nav-P").position().top < 20 && $("#nav-P").position().top > -20)
		{
			if(curp < $("#nav-P").position().top)
				changeNavIndicator("O");
			else
				changeNavIndicator("P");
			curp = $("#nav-P").position().top;
		}	
		if($("#nav-Q").position().top < 20 && $("#nav-Q").position().top > -20)
		{
			if(curq < $("#nav-Q").position().top)
				changeNavIndicator("P");
			else
				changeNavIndicator("Q");
			curq = $("#nav-Q").position().top;
		}	
		if($("#nav-R").position().top < 20 && $("#nav-R").position().top > -20)
		{
			if(curr < $("#nav-R").position().top)
				changeNavIndicator("Q");
			else
				changeNavIndicator("R");
			curr = $("#nav-R").position().top;
		}	
		if($("#nav-S").position().top < 20 && $("#nav-S").position().top > -20)
		{
			if(curs < $("#nav-S").position().top)
				changeNavIndicator("R");
			else
				changeNavIndicator("S");
			curs = $("#nav-S").position().top;
		}	
		if($("#nav-T").position().top < 20 && $("#nav-T").position().top > -20)
		{
			if(curt < $("#nav-T").position().top)
				changeNavIndicator("S");
			else
				changeNavIndicator("T");
			curt = $("#nav-T").position().top;
		}	
		if($("#nav-U").position().top < 20 && $("#nav-U").position().top > -20)
		{
			if(curu < $("#nav-U").position().top)
				changeNavIndicator("T");
			else
				changeNavIndicator("U");
			curu = $("#nav-U").position().top;
		}	
		if($("#nav-V").position().top < 20 && $("#nav-V").position().top > -20)
		{
			if(curv < $("#nav-V").position().top)
				changeNavIndicator("U");
			else
				changeNavIndicator("V");
			curv = $("#nav-V").position().top;
		}	
		if($("#nav-W").position().top < 20 && $("#nav-W").position().top > -20)
		{
			if(curw < $("#nav-W").position().top)
				changeNavIndicator("V");
			else
				changeNavIndicator("W");
			curw = $("#nav-W").position().top;
		}	
		if($("#nav-X").position().top < 20 && $("#nav-X").position().top > -20)
		{
			if(curx < $("#nav-X").position().top)
				changeNavIndicator("W");
			else
				changeNavIndicator("X");
			curx = $("#nav-X").position().top;
		}	
		if($("#nav-Y").position().top < 20 && $("#nav-Y").position().top > -20)
		{
			if(cury < $("#nav-Y").position().top)
				changeNavIndicator("X");
			else
				changeNavIndicator("Y");
			cury = $("#nav-Y").position().top;
		}	
	    if($("#nav-Z").position().top < 20 && $("#nav-Z").position().top > -20)
		{
			if(curz < $("#nav-Z").position().top)
				changeNavIndicator("Y");
			else
				changeNavIndicator("Z");
			curz = $("#nav-Z").position().top;
		}	
		// Fade the indicator, staying CSS2.1 valid
		$("#nav-indicator-fixed").fadeTo(1, 0.85);
	});
});