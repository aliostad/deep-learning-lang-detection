/**
 * MAIN.JS
 */

// Ready?
document.addEventListener("DOMContentLoaded", function(event) {


    /**
     * MENU NAV TOGGLE
     */
    var navToggle = document.getElementById('js-nav-toggle')
        nav = document.getElementById('js-nav'),
        body = document.body;


    var navController = {
        open: false
    }

    // Toggle Nav
    navToggle.addEventListener('click', function (event) {

        if(navController.open) {
            body.id = '';
            navController.open = false;
        } else {
            body.id = 'js-nav-is-open';
            navController.open = true;
        }

        event.preventDefault();
    });





    /**
     * INIT SMOOTH SCROLL
     */
    smoothScroll.init();

});
