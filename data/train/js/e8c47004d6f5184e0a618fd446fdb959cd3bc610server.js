(function ($) {
    /*
     * Make sure jquery is loaded
     */
    if (!$) {
        return;
    }
    $('#login').submit(function (e) {
        e.preventDefault();
    });
    $('input[name=loginType]').change(function () {
        var type = $(this).val();
        switch (type) {
            case '1':
                $('.lrf').hide();
                $('.loginShow').show();
                break;
            case '2':
                $('.lrf').hide();
                $('.registerShow').show();
                break;
            case '3':
                $('.lrf').hide();
                $('.forgotShow').show();
                break;
        }
    });
    $('.lrf').hide();
    $('.loginShow').show();
})(jQuery);