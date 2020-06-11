;
define(function(require, exports) {
    var $ = require('jquery');
    var $header = $("#header");
    var $nav = $("#nav");
    var $topNav = $("#top-nav");
    $nav.on("click", "dt", function() {
        var $this = $(this);
        $this.addClass('nav-current').siblings('dt').removeClass('nav-current');
        $this.next('dd').show().siblings('dd').hide();
    });
    $nav.on("click", "a", function() {
        $nav.find('.cur').removeClass('cur');
        $topNav.find('.current-nav').removeClass('current-nav');
        $(this).addClass('cur');
    });
    /*var windowHeight = $(window).height();
     var bodyHeight = $(document).height();
     var headerHeight = $header.height();
     if ( bodyHeight >= windowHeight ) {
     $nav.css("min-height", bodyHeight-headerHeight);
     } else {
     $nav.css("min-height", windowHeight-headerHeight);
     }*/
    $topNav.on("click", "a", function() {
        $topNav.find('.current-nav').removeClass('current-nav');
        $nav.find('.nav-current').removeClass('nav-current').next('dd').hide().find('.cur').removeClass('cur');
        $(this).addClass('current-nav');
    });
    $("#login-out").on("click", function() {
        // location.href = "login.html";
    });
});