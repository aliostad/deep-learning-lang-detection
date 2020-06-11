<?php

defined( 'ABSPATH' ) || die();

/**
* If "show" is set to false or "0", then the 
* entire metabox will be removed.  This needs to run every time.
* 
* For user specific dashboard item control 
* use get_dashboard_user_data(), below.
*/
function get_dashboard_data(){
    $items = array ( 
        array ( 'name' => 'dashboard_right_now', 'location' => 'normal', 'show' => 0 ),
        array ( 'name' => 'dashboard_show_welcome_panel', 'location' => 'normal', 'show' => 0 ),
        array ( 'name' => 'network_dashboard_right_now', 'location' => 'normal', 'show' => 0 ),
        array ( 'name' => 'dashboard_activity', 'location' => 'normal', 'show' => 0 ),
        array ( 'name' => 'dashboard_quick_press', 'location' => 'normal', 'show' => 0 ),
        array ( 'name' => 'dashboard_primary', 'location' => 'normal', 'show' => 0 ),
        array ( 'name' => 'lp_dashboard_widget', 'location' => 'side', 'show' => 0 ),
        array ( 'name' => 'dashboard_incoming_links', 'location' => 'normal', 'show' => 0 ),
        array ( 'name' => 'dashboard_plugins', 'location' => 'normal', 'show' => 0 ),
        array ( 'name' => 'dashboard_secondary', 'location' => 'normal', 'show' => 0 ),
        array ( 'name' => 'dashboard_incoming_links', 'location' => 'normal', 'show' => 0 ),
        array ( 'name' => 'dashboard_recent_drafts', 'location' => 'side', 'show' => 0 ),
        array ( 'name' => 'dashboard_recent_comments', 'location' => 'normal', 'show' => 0 ),
        );
    return $items;
}

function get_dashboard_user_data(){
    $items = array ( 
        array ( 'name' => 'dashboard_right_now', 'show' => 0 ),
        array ( 'name' => 'dashboard_show_welcome_panel', 'show' => 0 ),
        array ( 'name' => 'dashboard_activity', 'show' => 0 ),
        array ( 'name' => 'dashboard_quick_press', 'show' => 0 ),
        array ( 'name' => 'dashboard_primary', 'show' => 0 ),
        array ( 'name' => 'lp_dashboard_widget', 'show' => 0 ),
        array ( 'name' => 'dashboard_incoming_links', 'show' => 0 ),
        array ( 'name' => 'dashboard_plugins', 'show' => 0 ),
        array ( 'name' => 'dashboard_secondary', 'show' => 0 ),
        array ( 'name' => 'dashboard_incoming_links', 'show' => 0 ),
        array ( 'name' => 'dashboard_recent_drafts', 'show' => 0 ),
        array ( 'name' => 'dashboard_recent_comments', 'show' => 0 ),
        );
    return $items;
}
