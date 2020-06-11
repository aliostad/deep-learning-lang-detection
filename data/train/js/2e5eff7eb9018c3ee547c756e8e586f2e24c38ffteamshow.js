//called by team_info_page.php -- max number of teams is 10 for this
function showTeam(input) {
	if(input == 'show_'){
		$('#show_').addClass("active");
		$('#hide_').removeClass("active");
    $('#t1').show();
    $('#t2').show();
    $('#t3').show();
    $('#t4').show();
    $('#t5').show();
    $('#t6').show();
    $('#t7').show();
    $('#t8').show();
    $('#t9').show();
    $('#t10').show();

	}
	else if(input == 'hide_'){
		$('#hide_').addClass("active");
		$('#show_').removeClass("active");
		$('#t1').hide();
		$('#t2').hide();
    $('#t3').hide();
    $('#t4').hide();
    $('#t5').hide();
    $('#t6').hide();
    $('#t7').hide();
    $('#t8').hide();
    $('#t9').hide();
    $('#t10').hide();

	}else{
    $('#t'.concat(input)).toggle();

  }
}
