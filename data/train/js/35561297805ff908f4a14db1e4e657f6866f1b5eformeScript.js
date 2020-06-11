$(document).ready(function(){
    //                                                              Functions
    function clickShow(unhide) {
        $(".paragraph").hide();
        $(unhide).show();
    }
    function clickShowFade(unhide) {
        $(".paragraph").fadeOut(400);
        $(unhide).delay(400).fadeIn(400);
    }
    
    //                                                              OnClicks
    $(".summary").click(function(){clickShowFade("#psummary")});
    $(".family").click(function(){clickShowFade("#pfamily")});
    $(".career").click(function(){clickShowFade("#pcareer")});
    $(".friendship").click(function(){clickShowFade("#pfriendship")});
    $(".recreation").click(function(){clickShowFade("#precreation")});
    $(".spiritual").click(function(){clickShowFade("#pspiritual")});
    //Begin script to show only summary
    clickShow("#psummary");
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
});
