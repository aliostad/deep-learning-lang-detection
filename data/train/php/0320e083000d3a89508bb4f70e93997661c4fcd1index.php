<?php
define("CONF_PATH_RELATIVE",'.');
require("config.php");
require('include/php/connect/database.php');
require("include/php/classes/bviews.php");

b_set_time_zone("Asia/Jakarta");
$bviews=new BViews($db_link);
$arr_request=arr_request();
switch($arr_request[0]){
	case "":
		$bviews->show_header("Home");//HEADER-----------------------------------
		$bviews->show_home();
		break;
	case "home.html":
		$bviews->show_header("Home");//HEADER-----------------------------------
		$bviews->show_home();
		break;
	case "products":
		$bviews->show_header("Products");//HEADER-----------------------------------
		$bviews->show_products();
		break;
	case "page":
		$title=$arr_request[1];
		$bviews->show_header($title);//HEADER-----------------------------------
		$bviews->show_page($title);
		break;
	case "catalog":
		$bviews->show_header("Catalog Request");//HEADER-----------------------------------
		$bviews->show_catalog();
		break;
	default:
		$bviews->show_header("Home");//HEADER-----------------------------------
		$bviews->show_home();
		break;
}

$bviews->show_footer();//FOOTER-----------------------------------
?>