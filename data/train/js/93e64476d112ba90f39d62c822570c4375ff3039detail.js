$(function(){

    var $header = $('#header'),
        $nav = $('#nav'),
        $navIcon = $('.nav-icon',$header),
        $navClose = $('.close',$nav);




    //导航
    $navIcon.on('click',function(){
        $nav.animate({
            top: 0
        });
    });
    $navClose.on('click',function(){
        $nav.animate({
            top: -192
        });
    });




    // top-top返回顶部
    $().UItoTop({ easingType: 'easeOutQuart' });
    // 锚点跳转
    $(".scroll").click(function(event){
        event.preventDefault();
        $('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
    });






});