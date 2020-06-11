!function() {

    $('.nav-button__holder').on('click', function(e) {
        $('body').toggleClass('js-nav--open');
        if ($(e.target).hasClass('menu')) {
            return false;
        }
        e.preventDefault();
        return false;
    });

    $('body').append('<div class="nav--mask"></div>');

    $('.section--nav').insertAfter('.section--head');
    $($('.section--head .site-title')[0].parentNode).append($('.section--nav .nav-button__holder'));

    var lastHoverOver = null,
        hovering = false,
        pauseCloseInProgress = false;
    function navSubToggle(e) {
        $('body').toggleClass('js-nav--open');
    }
    function navSubOpen(e) {
        $('body').addClass('js-nav--open');
        hovering = true;
    }
    function navSubClose(e) {
        $('body').removeClass('js-nav--open');
    }
    function navSubPauseClose() {
        hovering = false;
        if (!pauseCloseInProgress) {
            pauseCloseInProgress = true;
            setTimeout(function() {
                pauseCloseInProgress = false;
                if (!hovering) {
                    navSubClose();
                }
            }, 1000);
        }
    }
    $('.nav').on('mouseover', navSubOpen);
    $('.nav').on('mouseout', navSubPauseClose);
    $('.nav').on('focus', navSubOpen);
    $('.nav').on('blur', navSubClose);
    $('.nav--mask').on('click', navSubClose);

}();