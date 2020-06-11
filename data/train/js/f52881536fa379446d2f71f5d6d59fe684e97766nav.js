$(function(){

    //擦除效果
    jQuery.extend(jQuery.easing,
        {
            easeOutBack: function (x, t, b, c, d, s) {
                s = s || 1.3;
                return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
        }
    });
    
    //nav初始化选中
    var navCurr = $("#navCurr");
    $("#navSelected").css("left", navCurr[0].offsetLeft);
    
    //nav里的链接hover效果
    $("#navBd li").hover(function(){
            if(!!$("#navSelected").stop(true).animate({left:$(this)[0].offsetLeft}, 400, "easeOutBack")) {
                $(this).siblings().removeClass("navHover").end().addClass("navHover");
                $(this).find("a").hide().fadeIn(300);
            }
            
        }, function(){
            $(this).removeClass("navHover");
            $("#navCurr").addClass("navHover");
            //window.setTimeout(function(){$("#navCurr").parent().addClass("navHover")},100);
            $("#navSelected").stop(true).animate({left:navCurr[0].offsetLeft}, 300, "easeOutBack");
        }
    );

})