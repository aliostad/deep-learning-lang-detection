/**
 * Created by Ben on 8/10/2015.
 */

var navHeight = 45;
var placeholderHeight = 10;

$(document).ready(function(){

    var viewportHeight = $(window).height();
    var initialNavTop = $('#navPlaceholder').offset().top - $(document).scrollTop();

    StickNav(initialNavTop);

    $(window).scroll(function(){
        var navBarTop = $('#navPlaceholder').offset().top - $(document).scrollTop();

        StickNav(navBarTop);
    })

    function StickNav(topOfNav){
        if(topOfNav <= navHeight){
            $('#stickyNav').addClass('stickToTop');
            $('#navPlaceholder').css('height', '45px');
        }
        if(topOfNav > navHeight){
            $('#stickyNav').removeClass('stickToTop');
            $('#navPlaceholder').css('height', '10px');
        }
        if(topOfNav - placeholderHeight >= viewportHeight){
            $('#stickyNav').addClass('stickToBottom');
        }
        if(topOfNav - placeholderHeight < viewportHeight) {
            $('#stickyNav').removeClass('stickToBottom');
        }
    }
});
