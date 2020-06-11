function generateNav() {
	var nav = new Array();
	for (var i = 0; i < 2; i ++) nav[i] = new Array();
	nav[0][0] = "abt";
	nav[1][0] = "About";
	
	nav[0][1] = "prj";
	nav[1][1] = "Projects";
	
	nav[0][2] = "ptg";
	nav[1][2] = "Photography";
	
	nav[0][3] = "blg";
	nav[1][3] = "Blog";
	
	nav[0][4] = "line";
	nav[1][4] = "";
	
	nav[0][5] = "uwat";
	nav[1][5] = "U Waterloo";
	
	nav[0][6] = "tedx";
	nav[1][6] = "TEDx";
	
	nav[0][7] = "line";
	nav[1][7] = "";
	
	nav[0][8] = "lin";
	nav[1][8] = "LinkedIn";
	
	nav[0][9] = "ctt";
	nav[1][9] = "Contact";
	
	
	var k = 0;
	while (nav[0][k] != null) {
		var content = document.getElementById('nav').innerHTML;
		document.getElementById('nav').innerHTML = content + "<div id=\"" + nav[0][k] + "\" class=\"nav\" onclick=\"go" + nav[0][k] + "();\">" + nav[1][k] + "</div>" ;
		k ++;
	}

}