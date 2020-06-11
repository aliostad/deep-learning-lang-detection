<?php

if (!isset($GLOBALS['PHORUM']['mod_show_moderators'])) {
    $GLOBALS['PHORUM']['mod_show_moderators'] = array();
}

if (!isset($GLOBALS['PHORUM']['mod_show_moderators']['cache'])) {
    $GLOBALS['PHORUM']['mod_show_moderators']['cache'] = 3600;
}

if (!isset($GLOBALS['PHORUM']['mod_show_moderators']['include_admins'])) {
    $GLOBALS['PHORUM']['mod_show_moderators']['include_admins'] = FALSE;
}

if (!isset($GLOBALS['PHORUM']['mod_show_moderators']['show_on_index'])) {
    $GLOBALS['PHORUM']['mod_show_moderators']['show_on_index'] = 1;
}

if (!isset($GLOBALS['PHORUM']['mod_show_moderators']['show_on_list'])) {
    $GLOBALS['PHORUM']['mod_show_moderators']['show_on_list'] = 1;
}

if (!isset($GLOBALS['PHORUM']['mod_show_moderators']['show_on_read'])) {
    $GLOBALS['PHORUM']['mod_show_moderators']['show_on_read'] = 1;
}

?>
