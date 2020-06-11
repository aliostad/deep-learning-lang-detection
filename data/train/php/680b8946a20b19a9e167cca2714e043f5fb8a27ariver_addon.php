<?php
/**
 * River Addon function library
 */

function river_addon_get_modules() {

	$settinglist = array(
		'show_icon_order',
		'show_menu_order',
		'show_latest_members_order',
		'show_friends_order',
		'show_friends_online_order',
		'show_ticker_order',
		'show_groups_order',
		'show_latest_groups_order',
		'show_tagcloud_order',
		'show_custom_order',
		'show_albums_order',
		'show_comments_order'
	);
	$modules = array();
		
	foreach ($settinglist as $key => $name) {
		$modules[$key] = elgg_echo("$name");
	}
	
	return $modules;	
}
