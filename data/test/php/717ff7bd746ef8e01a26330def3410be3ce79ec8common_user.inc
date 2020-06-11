<?php
define("COMMON_USER_INC", true);
if (!defined("USER_INC"))
  include("dbapi/user.inc");

define("SHOW_NAME", 1);
define("SHOW_EMAIL", 2);
define("SHOW_HOMEPAGE", 4);
define("SHOW_ABOUT", 8);
define("SHOW_FAVOURITES", 16);
define("SHOW_GENDER", 32);
define("SHOW_AGE", 64);
define("SHOW_INTERESTS", 128);
define("SHOW_COUNTRY", 256);
define("SHOW_PIC", 512);
define("SHOW_AIM", 1024);
define("SHOW_YAHOO", 2048);
define("SHOW_ICQ", 4096);
define("SHOW_MSN", 8192);

function show_var($value, $var){
 return (($value & $var) != 0);
}
?>