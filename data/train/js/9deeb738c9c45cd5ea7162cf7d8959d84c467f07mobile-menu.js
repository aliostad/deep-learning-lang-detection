        $("#mobile-nav-button").addClass("");
        $("#search-nav-button").addClass("");

            $("#mobile-nav-button").click(function(){
                $(this).toggleClass('mobile-nav-close');
                $("#mobile-nav").toggle();
            });

            $("#search-nav-button").click(function(){
                $(this).toggleClass('mobile-nav-close');
                $("#search-panel").toggle();
            });

        $(window).resize(function(){
                if(window.innerWidth > 800) {
                        $("#mobile-nav").removeAttr("style");
                        $("#mobile-nav-button").removeAttr("class");
                        $("#mobile-nav-button").removeClass("mobile-nav-close");
                }
        });



