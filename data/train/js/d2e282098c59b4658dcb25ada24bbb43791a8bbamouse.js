$(document).ready(function() {

  $("#weixin").mouseover(function(){
       $("#showWeixin").slideToggle();
       // $("#showWeixin").css("top",event.clientY+3);
      // $("#showWeixin").css("left",event.clientX+170);
  });
  $("#weixin").mouseout(function(){
      $("#showWeixin").hide();

  });
  $("#sina").mouseover(function(){
       $("#showSina").slideToggle();
       // $("#showSina").css("top",event.clientY+3);
      // $("#showSina").css("left",event.clientX+220);
  });
  $("#sina").mouseout(function(){
      $("#showSina").hide();

  });
});
