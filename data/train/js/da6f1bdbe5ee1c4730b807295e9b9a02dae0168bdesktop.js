$(document).ready(function() {
    //drop nav
    $('#nav-button').mouseenter(function() {
        $('#nav-menu').css('display', 'block');
        $('#nav-button').css('background', '#222222');
        $('#nav-button').css('color', '#DAA520');
    });
    //retract nav
    $('#nav-menu').mouseleave(function(){
        $('#nav-menu').css('display', 'none');
        $('#nav-button').css('background', '#DAA520');
        $('#nav-button').css('color', '#222222');
    });
    //nav click
    $('li').click(function() {
        if ($.cookie('mode') == 'ajax') {
            var page = $(this).attr('title');
            swapPage(page);
        }
    });
});
