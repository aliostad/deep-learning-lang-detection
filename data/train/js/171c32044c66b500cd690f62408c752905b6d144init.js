$(function() {

    var menu = $("#droplinetabs1 .nav");
    menu.each(function(i){
      var item = $(this)

    	item.hover(
    		function() {
                var nav = $(this).children(".nav-submenu")
                var nav_submenu = nav.children("ul")
                var W = nav.width();
                var padding = 10;
                var w = (W - 2*padding)/nav_submenu.length
                var l = navWidthCalculate($(this))

    			       nav.css({visibility: 'visible', left:l})
                          .slideDown(800)
                              .children("ul")
                                   .each(function(){
                                       $(this).width(w)
                                   })
    		},
    		function() {
                $(this).children(".nav-submenu")
                       .hide()
    		}
    	);

    })


});
