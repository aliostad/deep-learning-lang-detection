$("a").click(function(){
    var show = 'show-section';
    if ($(this).hasClass('about')){
    $(".about").toggleClass(show);
            $(".contact").removeClass('show-section');
    } else if ($(this).hasClass('contact')) {
        $(".contact").toggleClass('show-section');
            $(".about").removeClass('show-section');

    } else if ($(this).hasClass('work-link') || $(this).hasClass('close')) {
        $(".about").removeClass('show-section');
        $(".contact").removeClass('show-section');
    }

  });

