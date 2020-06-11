$(document).ready(function(){
  var userName = $('#isLogin').html();
  
  /* 로그인 되었을때 */
  if(userName != "Please login"){
    $('#login').hide();
    $('#register').hide();
    $('#span2').hide();
    $('#span1').hide();

    $('#logout').show();
    $('#userInfo').show();
    $('#span3').show();
    $('#span4').show();
  } else{
    $('#logout').hide();
    $('#userInfo').hide();
    $('#span3').hide();
    $('#span4').hide();

  }

  /* 로그아웃 클릭 되었을때 */
  $('#logout').click(function(){
    $('#login').show();
    $('#register').show();
    $('#span1').show();
    $('#span2').show();

    $('#logout').hide(); 
  });
});