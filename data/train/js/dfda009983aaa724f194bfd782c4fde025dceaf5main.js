jQuery(document).ready(function () {
    if ($('.cd-stretchy-nav').length > 0) {
        var stretchyNavs = $('.cd-stretchy-nav');
        var page = $('.appPage');
        var body = $('customBackground');

        stretchyNavs.each(function () {
            var stretchyNav = $(this)
                , stretchyNavTrigger = stretchyNav.find('.cd-nav-trigger');

            stretchyNavTrigger.on('click', function (event) {
                event.preventDefault();
                stretchyNav.toggleClass('nav-is-visible');
                page.toggleClass('forgroundDarkness');
                body.toggleClass('customBlur');
                stretchyNavs.toggleClass('stectchyNavSizeOpen');

            });
        });

        $(document).on('click', function (event) {
            (!$(event.target).is('.cd-nav-trigger') && !$(event.target).is('.cd-nav-trigger span')) && stretchyNav.removeClass('nav-is-visible');

            stretchyNavs.toggleClass('strecthyNavSizeClosed');

        });
    }
});