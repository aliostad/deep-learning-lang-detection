


$(document).ready(function() {

    $('.show-menu').click(function(event) {
        $('.show-menu2').fadeIn('fast');
    });

    $('.show-menu2').mouseleave(function(event) {
        $('.show-menu2').fadeOut('slow');
    });

    $('.show-menu2-item').mouseover(function(event) {
        var show = event.target.getAttribute('show');
        $('.show-menu2-item.' + show).css('background-color', 'blue');
        $('.show-menu2-item.' + show).css('color', 'white');
    });

    $('.show-menu2-item').mouseleave(function(event) {
        var show = event.target.getAttribute('show');
        $('.show-menu2-item.' + show).css('background-color', 'white');
        $('.show-menu2-item.' + show).css('color', 'black');
    });

    $('.show-menu2-item').click(function(event) {
        var show = event.target.getAttribute('show');
        window.location.href = '/shows/' + show;
    });
});
