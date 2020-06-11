jQuery(document).ready(function($){
    var $nav_div = $('.nav');
    var $nav_possition = $nav_div.offset().top;
    $(window).resize(function(event) {
        $nav_possition = $nav_div.offset().top;
    });
    $(window).scroll(function(event) {
        event.preventDefault();
        var $top_position_of_scroll = $(window).scrollTop();
        if ($top_position_of_scroll > $nav_possition){
            $nav_div.addClass('stick');
        }else{
            $nav_div.removeClass('stick');
        }
    });
});
