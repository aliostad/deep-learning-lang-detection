var nav_menu_timeout    = 777;
var nav_menu_closetimer = 0;
var nav_menuitem        = 0;

function nav_menu_open(){
    nav_menu_canceltimer();
    nav_menu_close();
    nav_menuitem = $(this).find('ul').eq(0).css('visibility', 'visible');
}
function nav_menu_close(){
    if(nav_menuitem) nav_menuitem.css('visibility', 'hidden');
}
function nav_menu_timer(){
    nav_menu_closetimer = window.setTimeout(nav_menu_close, nav_menu_timeout);
}
function nav_menu_canceltimer(){
    if(nav_menu_closetimer){
        window.clearTimeout(nav_menu_closetimer);
        nav_menu_closetimer = null;
    }
}

$(document).ready(
function(){
    $('.nav_menu > li').bind('mouseover', nav_menu_open);
    $('.nav_menu > li').bind('mouseout',  nav_menu_timer);
}
);

document.onclick = nav_menu_close;
