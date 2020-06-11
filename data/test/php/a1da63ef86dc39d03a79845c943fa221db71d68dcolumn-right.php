<?php
if(empty($dont_show_right)){
$dont_show = array();
}
//Uncomment items below to remove them from ALL PAGES for this template only

//Skinny column
//$dont_show_right[] = 'testimonials';
//$dont_show_right[] = 'last_winner';
//$dont_show_right[] = 'latest_news';
//$dont_show_right[] = 'right_social';
//$dont_show_right[] = 'coupon_menu';
//$dont_show_right[] = 'bidpack_menu';
//$dont_show_right[] = 'user_menu';
//$dont_show_right[] = 'help_menu';
//$dont_show_right[] = 'faq_menu';
//$dont_show_right[] = 'top_menu';
//$dont_show_right[] = 'search_box';
//$dont_show_right[] = 'category_menu';




array_push($dont_show_right, $dont_show);
load_addon_by_position('column-right', $addons, $admin, basename($_SERVER['PHP_SELF']), $dont_show_right);
