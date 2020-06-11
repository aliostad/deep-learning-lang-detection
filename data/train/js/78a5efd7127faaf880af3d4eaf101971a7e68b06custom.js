$(function () {
    $(window).on("scroll", function () {
        var $nav = $("nav[role='navigation']");

        if ($(this).scrollTop() > 0) {
            $nav.addClass("scrolled");
        }
        else {
            $nav.removeClass("scrolled");
        }
    });

    var $nav = $(".nav.nav-pills.nav-stacked");
    $nav.find('li').click(function(e) {
        var $this = $(this);
        if (!$this.hasClass('active')) {
            $nav.find("li.active").removeClass("active");
            $this.addClass('active');
        }
        e.preventDefault();
    });
});