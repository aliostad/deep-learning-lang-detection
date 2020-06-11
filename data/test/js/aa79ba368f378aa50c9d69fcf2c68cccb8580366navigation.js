$(document).ready( function() {


    //---------------------//
    //      VARIABLES      //
    //---------------------//
    
    // This variable keeps track of the active navigation icon
    active_nav = "";

    

    //---------------------//
    //      MOUSEOVER      //
    //---------------------//
    
    // This event listener adds the navUp animation when links
    // in the navigation are being mouseovered.
    $("#nav-home, #nav-profile, #nav-skill, #nav-workexp, #nav-contact").mouseover( function() {

        var object = $(this);

        // Finds the id of the current active nav icon
        active_nav = $(".nav-active").attr("id");

        // Check if tag has class navUp
        if( !(object.hasClass("navUp")) && (active_nav != object.attr("id")) ) {
             // Add animation to navigation icon
            object.addClass("navUp");

            // Set active nav to default style
            $("#" + active_nav).removeClass("nav-active");
        } 

    });



    //---------------------//
    //       MOUSEOUT      //
    //---------------------//
    
    // This event listener removes the navUp animation when links
    // in the navigation are being mouseout.
    $("#nav-home, #nav-profile, #nav-skill, #nav-workexp, #nav-contact").mouseout( function() {

            var object = $(this);
            
            if( active_nav != object.attr("id")) {
                // Remove animation to navigation icon
                object.removeClass("navUp");

                $("#" + active_nav).addClass("nav-active");
            }
    });
});


