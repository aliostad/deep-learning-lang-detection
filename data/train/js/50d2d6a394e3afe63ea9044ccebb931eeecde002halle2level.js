/* arrays for rollover button script to swap images */
        var navArray = new Array();
        navArray[0] = new Image();
        navArray[0].src = "http://brand.emich.edu/app/images/nav_books_off.gif";
        navArray[1] = new Image();
        navArray[1].src = "http://brand.emich.edu/app/images/nav_books_over.gif";
        navArray[2] = new Image();
        navArray[2].src = "http://brand.emich.edu/app/images/nav_help_off.gif";
        navArray[3] = new Image();
        navArray[3].src = "http://brand.emich.edu/app/images/nav_help_over.gif";
        navArray[4] = new Image();
        navArray[4].src = "http://brand.emich.edu/app/images/nav_about_off.gif";
        navArray[5] = new Image();
        navArray[5].src = "http://brand.emich.edu/app/images/nav_about_over.gif";
        navArray[6] = new Image();
        navArray[6].src = "http://brand.emich.edu/app/images/nav_catalog_off.gif";
        navArray[7] = new Image();
        navArray[7].src = "http://brand.emich.edu/app/images/nav_catalog_over.gif";
        navArray[8] = new Image();
        navArray[8].src = "http://brand.emich.edu/app/images/nav_indexes_off.gif";
        navArray[9] = new Image();
        navArray[9].src = "http://brand.emich.edu/app/images/nav_indexes_over.gif";
        navArray[10] = new Image();
        navArray[10].src = "http://brand.emich.edu/app/images/nav_ask_off.gif";
        navArray[11] = new Image();
        navArray[11].src = "http://brand.emich.edu/app/images/nav_ask_over.gif";
       
        function mseOver(num, image) {
                image.src = navArray[num].src;
        }

        function mseOut(num,image) {
                image.src = navArray[num].src;
        }