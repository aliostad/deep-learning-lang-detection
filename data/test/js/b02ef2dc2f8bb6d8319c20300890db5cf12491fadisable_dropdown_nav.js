/* disable nav item dropdowns for navbar-collapse */
/*
function disable_dropdown_nav() {
    $('#header_main_nav').find('a.dropdown-toggle').addClass('disabled');
}
*/
$(document).ready(function() {
    /*
    var nav_collapse_link = $('#nav_collapse_button');

    nav_collapse_link.click( function () {
        disable_dropdown_nav();
    });
    */
    // for iPad
    $('#nav_collapse_button').on("click touchstart", function () {
        //disable_dropdown_nav();
        $('#header_main_nav').find('a.dropdown-toggle').addClass('disabled');
    });

});