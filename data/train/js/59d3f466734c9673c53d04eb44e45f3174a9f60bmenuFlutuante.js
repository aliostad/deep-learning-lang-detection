$(window).scroll(function() {
    if($(this).scrollTop() > 90) {
        $('nav').css('position', 'fixed');
        $('nav').css('z-index', '9999');
        $('nav').css('top', '0');
        $('nav').css('margin-top', '5px');
        $('nav ul').css('background-color', '#C0000');
        $('nav').css('box-shadow', '0px 0px 0px');
         $('nav ul').css('box-shadow', '0px 0px 13px #000');
        $('nav').stop().animate({
            'background-color':'transparent'
        }, 100);  
       
    }else {
        $('nav').css('position', 'static');
        $('nav ul').css('box-shadow', '0px 0px 0px #000');
        $('nav').stop().animate({
           'background-color':'#C0000'
        }, 110);
        $('nav').css('box-shadow', '3px 3px 3px #000');
    }
});