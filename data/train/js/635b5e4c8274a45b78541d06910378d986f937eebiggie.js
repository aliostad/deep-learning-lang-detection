var navBtnFired = false;

$(document).ready(function () {
    $(".nav-btn").on('touchstart click', function () {
        if (!navBtnFired) {
            navBtnFired = true;
            setTimeout(function () {
                navBtnFired = false;
            }, 100);

            if ($("nav").css("height") == "60px") { // main nav height
                $("nav").css("height", "100%"); // full height of nav
            } else {
                $("nav").css("height", "60px"); // return to normal state
            }
        }
        return false;
    });
});