$(document).ready(function(){
/*
var show_email = $.cookie('hide_mail');

if( typeof show_email !== "undefined" && show_email == "no"){
 $("p").show();
}
else{
 $("p").hide();
 //$.cookie('hide_email', 'yes');
}*/


 $("#hide").click(function(){
    $("p").hide();
// $.cookie('hide_email','yes');
});

 $("#show").click(function(){
    $("p").show();
 //$.cookie('hide_email','no');
  });
});

//var show_email = $.cookie('hide_mail');

/*if( typeof show_email !== "undefined" && show_email == "no"){
 $("p").show();
}
else{
 $("p").hide;
 $.cookie('hide_email', 'yes');
}*/
