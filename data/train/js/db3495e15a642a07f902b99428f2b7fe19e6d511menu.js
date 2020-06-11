var timeout    = 500;
var closetimer = 0;
var ddmenuitem = 0;

function nav_global_open()
{  nav_global_canceltimer();
   nav_global_close();
   ddmenuitem = $(this).find('ul').css('visibility', 'visible');}

function nav_global_close()
{  if(ddmenuitem) ddmenuitem.css('visibility', 'hidden');}

function nav_global_timer()
{  closetimer = window.setTimeout(nav_global_close, timeout);}

function nav_global_canceltimer()
{  if(closetimer)
   {  window.clearTimeout(closetimer);
      closetimer = null;}}

$(document).ready(function()
{  $('#nav-global > li').bind('mouseover', nav_global_open)
   $('#nav-global > li').bind('mouseout',  nav_global_timer)});

document.onclick = nav_global_close;
