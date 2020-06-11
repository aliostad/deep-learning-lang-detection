require(['jquery'], function($) {
    'use strict';

    $(document).ready(function() {
        $('#nav .nav-collapse').click(function() {
            $('#nav .row .links').toggle();
        });

        $('#nav .row .links').click(function() {
            if($('#nav .nav-collapse').css('display') !== 'none') {
                $(this).toggle();
            }
        });
    });

    // Quickfix for hidden navigation bar due to resizing
    $(window).resize(function() {
        if(
            $(window).width() > 640
            && $('#nav .nav-collapse').css('display') === 'none'
            && $('#nav .row .links').css('display') === 'none'
        ) {
            $('#nav .row .links').css('display', 'block');
        }
    });
});
