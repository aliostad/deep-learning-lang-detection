function show_info(){
	$('#introduce').show();
	$('#contact').hide();
}

function show_contact(){
	$('#introduce').hide();
	$('#contact').show();

}


function show_donghua(){
	$('#donghua').show();
	$('#dongman').hide();
	$('#dshangwu').hide();
	$('#jishumanager').hide();
}

function show_dongman(){
	$('#donghua').hide();
	$('#dongman').show();
  $('#dshangwu').hide();
  $('#jishumanager').hide();
}

function show_shangwu(){
	$('#donghua').hide();
	$('#dongman').hide();
	$('#shangwu').show();
	$('#jishumanager').hide();
}

function show_jishumanager(){
	$('#donghua').hide();
	$('#dongman').hide();
	$('#dshangwu').hide();
	$('#jishumanager').show();
}




