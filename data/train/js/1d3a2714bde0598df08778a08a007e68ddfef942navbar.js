var timeout    = 500;
var closetimer = 0;
var ddmenuitem = 0;

function nav_open()
{  nav_canceltimer();
   nav_close();
   ddmenuitem = $(this).find('ul').css('visibility', 'visible');}

function nav_close()
{  if(ddmenuitem) ddmenuitem.css('visibility', 'hidden');}

function nav_timer()
{  closetimer = window.setTimeout(nav_close, timeout);}

function nav_canceltimer()
{  if(closetimer)
   {  window.clearTimeout(closetimer);
      closetimer = null;}}

$(document).ready(function()
{  $('#nav > li').bind('mouseover', nav_open)
   $('#nav > li').bind('mouseout',  nav_timer)});

document.onclick = nav_close;