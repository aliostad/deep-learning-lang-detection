$(document).ready(function(){
  $(".youki2").hide();
  $(".youki3").hide();
  $(".youki4").hide();
/*nav 1 click*/
  $("#nav-1").click(function(){
  $(".youki1").show();
  $(".youki2").hide();
  $(".youki3").hide();
  $(".youki4").hide();

  });
/*nav 2 click*/
  $("#nav-2").click(function(){
  $(".youki2").show();
  $(".youki1").hide();
  $(".youki3").hide();
  $(".youki4").hide();
  });
/*nav 3 click*/
  $("#nav-3").click(function(){
  $(".youki3").show();
  $(".youki1").hide();
  $(".youki2").hide();
  $(".youki4").hide();
  });
/*nav 4 click*/
  $("#nav-4").click(function(){
  $(".youki4").show();
  $(".youki1").hide();
  $(".youki2").hide();
  $(".youki3").hide();
  });



//nav 1
  $("#nav-1").mouseover(function(){
    $("#nav-1 div").css("width","100%");
    $("#nav-1 .navtext").css("color","#FFF")
  });
  $("#nav-1").mouseleave(function(){
    $("#nav-1 div").css("width","0%");
    $("#nav-1 .navtext").css("color","#009CFF")
  });
//nav 2
  $("#nav-2").mouseover(function(){
    $("#nav-2 div").css("width","100%");
    $("#nav-2 .navtext").css("color","#FFF")
  });
  $("#nav-2").mouseleave(function(){
    $("#nav-2 div").css("width","0%");
    $("#nav-2 .navtext").css("color","#009CFF")
  });
//nav 3
  $("#nav-3").mouseover(function(){
    $("#nav-3 div").css("width","100%");
    $("#nav-3 .navtext").css("color","#FFF")
  });
  $("#nav-3").mouseleave(function(){
    $("#nav-3 div").css("width","0%");
    $("#nav-3 .navtext").css("color","#009CFF")
  });
//nav 4
  $("#nav-4").mouseover(function(){
    $("#nav-4 div").css("width","100%");
    $("#nav-4 .navtext").css("color","#FFF")
  });
  $("#nav-4").mouseleave(function(){
    $("#nav-4 div").css("width","0%");
    $("#nav-4 .navtext").css("color","#009CFF");
  });


});
