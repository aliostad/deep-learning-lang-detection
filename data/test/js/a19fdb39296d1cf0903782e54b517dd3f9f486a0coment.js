function show_it(idea){ 
	if(document.getElementById("showit"+idea).checked)
	{
		$("#cidea_"+idea).show();
		$("#hide"+idea).show();
		$("#show"+idea).hide();
	}
	else
	{
		$("#cidea_"+idea).hide();
		$("#hide"+idea).hide();
		$("#show"+idea).show();
	}
}
$(document).ready(function() {
	$("#show_profile").click(function(){
                $("#show_initial").show();
		$("#profile").show();
		$("#show_profile").hide();
		$("#feed").hide();
	});

	$("#show_initial").click(function(){
                $("#show_initial").hide();
		$("#profile").hide();
		$("#show_profile").show();
		$("#feed").show();
	});
});
