$(document).ready(function () {
    $('#unfix-nav').hide();

    $('#fix-nav').click(function () {
        $('.desktop-nav').css({
            'position': 'fixed',
            'top': 0,
            'left': 0
        });
        $('.main-header').css('margin-top', '3rem');
        $(this).hide();
        $('#unfix-nav').css({
            'font-weight': 'bold',
            'color': '#001489'
        });
        $('#unfix-nav').show();
    });

    $('#unfix-nav').click(function () {
        $('.desktop-nav').css({
            'position': 'unset',
            'top': 'unset',
            'left': 'unset'
        });
        $('.main-header').css('margin-top', 'unset');
        $(this).hide();
        $('#fix-nav').show();
    });
});
