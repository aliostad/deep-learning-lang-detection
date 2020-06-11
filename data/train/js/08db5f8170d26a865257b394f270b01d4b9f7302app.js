$(function(){

    $('#search-drop').click(function () {
    if ($('#show-search').is(":visible")){
        $('#show-login').hide();
        $('#show-search').slideToggle();
    } else {
        $('#show-login').hide();
        $('#show-search').slideToggle();
    }
        return false;
    });

    $('#login-drop').click(function () {
    if ($('#show-login').is(":visible")){
        $('#show-search').hide();
        $('#show-login').slideToggle();
    } else {
        $('#show-search').hide();
        $('#show-login').slideToggle();
    }    
        return false;
    });
});