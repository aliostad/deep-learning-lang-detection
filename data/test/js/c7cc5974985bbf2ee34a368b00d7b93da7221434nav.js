$(function() {
    var nav = $('#nav');
    var navHomeY = nav.offset().top;
    var isFixed = false;
    var $w = $(window);
    $w.scroll(function() {
        var scrollTop = $w.scrollTop();
        var shouldBeFixed = scrollTop > navHomeY;
        if (shouldBeFixed && !isFixed) {
            nav.css({
                position: 'fixed',
                top: 0,
                left: nav.offset().left,
                width: nav.width()
            });
            isFixed = true;

            $('#nav a').css({
                "border": "none"
            });
        }
        else if (!shouldBeFixed && isFixed)
        {
            nav.css({
                position: 'static'
            });

            $('#nav a').css({
                "border-right": "5px solid #AFE4C3"
            });
            
            isFixed = false;
        }
    });
});
