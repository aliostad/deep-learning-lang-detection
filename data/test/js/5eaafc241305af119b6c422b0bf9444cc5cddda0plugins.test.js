(function($) {
    test("Stackable admin main navigation", function() {

        ok($(".main-nav"), "Main nav exists in page");

        $(".main-nav").width("800px");
        $(".main-nav").stackable();

        ok(!$(".main-nav").hasClass("main-nav-stacked"), "Main nav should NOT have the main-nav-stacked class on page load (nav element width: 800px)");

        $(".main-nav").width("100px");
        $(window).trigger('resize').trigger('resize');

        ok($(".main-nav").hasClass("main-nav-stacked"), "Main nav should have the main-nav-stacked class on window resize (nav element width: 100px)");

        $(".main-nav").width("800px");
        $(window).trigger('resize').trigger('resize');

        ok(!$(".main-nav").hasClass("main-nav-stacked"), "Main nav should NOT have the main-nav-stacked after resizing the window again (nav element width: 800px)");

        $("<style>")
            .prop("type", "text/css")
            .html(".main-nav.main-nav-stacked ul li {\
                    display: block; \
                    width: 40%; \
                    margin-right: 10%; \
            }")
            .appendTo("head");

        $(".main-nav").width("100px");
        $(window).trigger('resize').trigger('resize');

        ok($(".main-nav").hasClass("main-nav-stacked"), "Main nav should have the main-nav-stacked class on window resize, even when LI's have width (nav element width: 100px)");

        $(".main-nav").width("800px");
        $(window).trigger('resize').trigger('resize');

        ok(!$(".main-nav").hasClass("main-nav-stacked"), "Main nav should NOT have the main-nav-stacked after resizing the window again - when LI's have width (nav element width: 800px)");

    });

})(jQuery);