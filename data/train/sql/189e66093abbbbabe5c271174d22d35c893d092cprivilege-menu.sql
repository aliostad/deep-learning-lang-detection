insert into plugins (id, name, testedUpTo, stableTag, requiresAtLeast, created, modified) values (3362, "Privilege Menu", "4.1", "1.5", "3.8", now(), now());

insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (446712, 3362, "Priv_Menu_Walker", "start_el", "/customWalker.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (446713, 3362, "privMenu", "edit_priv_menu_walker", "/privMenu.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (446714, 3362, "privMenu", "_action_init", "/privMenu.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (446715, 3362, "Priv_Menu_Walker", "start_lvl", "/customWalker.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (446716, 3362, "privMenu", "save_extra_menu_opts", "/privMenu.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (446717, 3362, "Priv_Menu_Walker", "end_lvl", "/customWalker.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (446718, 3362, "privMenu", "remove_menu_items", "/privMenu.php", now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (36969, 3362, "wp_update_nav_menu_item", "array($myprivMenuClass,'save_extra_menu_opts')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (36970, 3362, "plugins_loaded", "array($myprivMenuClass,'_action_init')", 10, now(), now());
insert into filters (id, plugin_id, tag_name, filter_callback, filter_priority, created, modified) values (12612, 3362, "wp_edit_nav_menu_walker", "array($myprivMenuClass,'edit_priv_menu_walker')", 10, now(), now());
insert into filters (id, plugin_id, tag_name, filter_callback, filter_priority, created, modified) values (12613, 3362, "wp_get_nav_menu_items", "array($myprivMenuClass,'remove_menu_items')", 10, now(), now());