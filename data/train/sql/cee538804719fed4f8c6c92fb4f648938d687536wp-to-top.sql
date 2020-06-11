insert into plugins (id, name, testedUpTo, stableTag, requiresAtLeast, created, modified) values (5474, "WP To Top", "4.1.1", "2.0", "2", now(), now());

insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (714889, 5474, "WP_To_Top_Admin", "add_css", "/classes/class-wp-to-top-admin.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (714890, 5474, "WP_To_Top", "__construct", "/classes/class-wp-to-top.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (714891, 5474, "WP_To_Top", "append_html", "/classes/class-wp-to-top.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (714892, 5474, "WP_To_Top_Admin", "__construct", "/classes/class-wp-to-top-admin.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (714893, 5474, "WP_To_Top_Admin", "add_menu", "/classes/class-wp-to-top-admin.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (714894, 5474, "WP_To_Top", "add_css", "/classes/class-wp-to-top.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (714895, 5474, "WP_To_Top_Admin", "register_settings", "/classes/class-wp-to-top-admin.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (714896, 5474, "WP_To_Top_Admin", "settings_page", "/classes/class-wp-to-top-admin.php", now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (59328, 5474, "admin_init", "array($this,'register_settings')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (59329, 5474, "wp_enqueue_scripts", "array($this,'add_css')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (59330, 5474, "wp_footer", "array($this,'append_html')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (59331, 5474, "admin_menu", "array($this,'add_menu')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (59332, 5474, "admin_enqueue_scripts", "array($this,'add_css')", 10, now(), now());
