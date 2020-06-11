insert into plugins (id, name, testedUpTo, stableTag, requiresAtLeast, created, modified) values (2147, "Let there be guides!", "4.0", "3.0", "3.0.1", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (40207, 2147, "huula_plugin_settings_link", "/huula.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (325321, 2147, "WP_Plugin_HuuLa", "settings_field_site_id", "/huula.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (325322, 2147, "WP_Plugin_HuuLa", "admin_init", "/huula.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (325323, 2147, "WP_Plugin_HuuLa", "admin_menu", "/huula.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (325324, 2147, "WP_Plugin_HuuLa", "sanitize_site_id", "/huula.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (325325, 2147, "WP_Plugin_HuuLa", "__construct", "/huula.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (325326, 2147, "WP_Plugin_HuuLa", "activate", "/huula.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (325327, 2147, "WP_Plugin_HuuLa", "check_generate_site_id", "/huula.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (325328, 2147, "WP_Plugin_HuuLa", "deactivate", "/huula.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (325329, 2147, "WP_Plugin_HuuLa", "plugin_settings_page", "/huula.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (325330, 2147, "WP_Plugin_HuuLa", "append_script_code", "/huula.php", now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (22784, 2147, "admin_menu", "array(&$this,'admin_menu')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (22785, 2147, "admin_init", "array(&$this,'admin_init')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (22786, 2147, "wp_head", "array(&$this,'append_script_code')", 10, now(), now());
