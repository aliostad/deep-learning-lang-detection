$(function () { 
	$("[data-toggle='tooltip']").tooltip(); 
	});
$("#editEmail").click(function(){
  $("#emailForm").show();
  $("#emailVlaue").hide();
  $(this).hide();
  if($("#passwordForm").show()){
  	$("#passwordForm").hide();
  	$("#passwordValue").show();
  	$("#editPassword").show();
  }
});
$("#backEmail").click(function(){
	$("#emailForm").hide();
	$("#emailVlaue").show();
	$("#editEmail").show();
});
$("#editPassword").click(function(){
  $("#passwordForm").show();
  $("#passwordValue").hide();
  $(this).hide();
  if($("#emailForm").show()){
  	$("#emailForm").hide();
  	$("#emailVlaue").show();
  	$("#editEmail").show();
  }
});
$("#backPassword").click(function(){
  $("#passwordForm").hide();
  $("#passwordValue").show();
  $("#editPassword").show();
});