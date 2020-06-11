$(function(){
    $topNav = $(".container_top-nav");

    var $modal = $(".modal_window");
    $("#communication").click(function(e){
        e.preventDefault();
        $modal.fadeIn();
    });

    $(".close_modal").click(function(e){
        e.preventDefault();
        $modal.fadeOut();
    });

    $.scrollIt();

    function navScroll(){
        if( $("#mobile").hasClass("active") || $(".emptyNavBtn").hasClass("active") ){
            $topNav.addClass("scrollNav");
        }else{
            $topNav.removeClass("scrollNav");
        }
    }

    $(window).scroll(function(){
        navScroll();
    });

    $('.b0').parallax("50%", 0);
});