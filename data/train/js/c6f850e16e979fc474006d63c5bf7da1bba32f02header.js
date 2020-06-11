$(document).ready(function () {
    var header_open = false;

    $(".nav-brand").hover(function () {
        if ($(window).width() > 768) {
            $(".nav-contents div").removeClass("nav-open");
            $(".nav-contents .nav-brand").addClass("nav-open");
            $("body").addClass("body-pushdown");
            $(".nav-brand").addClass("hover-current");
            header_open = true;
        }
    }, function () {
        if ($(window).width() > 768) {
        	$(".nav-brand").removeClass("hover-current");
        }
    });

    $(".nav-about").hover(function () {
        if ($(window).width() > 768) {
            $(".nav-contents div").removeClass("nav-open");
            $(".nav-contents .nav-about").addClass("nav-open");
            $("body").addClass("body-pushdown");
            $(".nav-about").addClass("hover-current");
            header_open = true;
        }
    }, function () {
        if ($(window).width() > 768) {
        	$(".nav-about").removeClass("hover-current");
        }
    });

    $(".nav-academics").hover(function () {
        if ($(window).width() > 768) {
            $(".nav-contents div").removeClass("nav-open");
            $(".nav-contents .nav-academics").addClass("nav-open");
            $("body").addClass("body-pushdown");
            $(".nav-academics").addClass("hover-current");
            header_open = true;
        }
    }, function () {
        if ($(window).width() > 768) {
        	$(".nav-academics").removeClass("hover-current");
        }
    });

    $(".nav-research").hover(function () {
        if ($(window).width() > 768) {
            $(".nav-contents div").removeClass("nav-open");
            $(".nav-contents .nav-research").addClass("nav-open");
            $("body").addClass("body-pushdown");
            $(".nav-research").addClass("hover-current");
            header_open = true;
        }
    }, function () {
        if ($(window).width() > 768) {
        	$(".nav-research").removeClass("hover-current");
        }
    });

    $(".nav-portfolio").hover(function () {
        if ($(window).width() > 768) {
            $(".nav-contents div").removeClass("nav-open");
            $(".nav-contents .nav-portfolio").addClass("nav-open");
            $("body").addClass("body-pushdown");
            $(".nav-portfolio").addClass("hover-current");
            header_open = true;
        }
    }, function () {
        if ($(window).width() > 768) {
        	$(".nav-portfolio").removeClass("hover-current");
        }
    });

    $(".nav-people").hover(function () {
        if ($(window).width() > 768) {
            $(".nav-contents div").removeClass("nav-open");
            $(".nav-contents .nav-people").addClass("nav-open");
            $("body").addClass("body-pushdown");
            $(".nav-people").addClass("hover-current");
            header_open = true;
        }
    }, function () {
        if ($(window).width() > 768) {
        	$(".nav-people").removeClass("hover-current");
        }
    });

    $(".nav-news").hover(function () {
        if ($(window).width() > 768) {
            $(".nav-contents div").removeClass("nav-open");
            $(".nav-contents .nav-news").addClass("nav-open");
            $("body").addClass("body-pushdown");
            $(".nav-news").addClass("hover-current");
            header_open = true;
        }
    }, function () {
        if ($(window).width() > 768) {
        	$(".nav-news").removeClass("hover-current");
        }
    });


    $("nav").hover(function () {
        if ($(window).width() > 768) {
            $(".nav-contents").addClass("nav-open");
            $("body").addClass("body-pushdown");
            if (header_open == false) {
                $(".nav-contents .nav-brand").addClass("nav-open");
            }
            header_open = true;
        }
    }, function () {
        if ($(window).width() > 768) {
            $(".nav-contents div").removeClass("nav-open");
            $("body").removeClass("body-pushdown");
            $(".nav-contents").removeClass("nav-open");
            header_open = false;
        }
    });

});