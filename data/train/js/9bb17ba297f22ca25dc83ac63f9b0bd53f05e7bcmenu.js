/**
 * Created by Anirudh on 8/30/2015.
 */


$(document).ready(function(){
    $(".menu_block").mouseenter(function(){

        var id = this.id;

        switch (id){

            case "home_nav":
                $("#home_nav").fadeTo('fast', 1.0);
                break;
            case "about_nav":
                $("#about_nav").fadeTo('fast', 1.0);
                break;
            case "login_nav":
                $("#login_nav").fadeTo('fast', 1.0);
                break;
            case "contact_nav":
                $("#contact_nav").fadeTo('fast', 1.0);
                break;
        }

    });


    $(".menu_block").mouseleave(function(){

       $(".menu_block").fadeTo('fast', 0.5);

    });


});