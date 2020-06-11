insert into plugins (id, name, testedUpTo, stableTag, requiresAtLeast, created, modified) values (390, "Plugin Name", "4.1", "4.3", "3.0.1", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (6135, 390, "wp_expand_autoplay_music_jquery", "/plugin-main.php", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (6136, 390, "append_music_to_body", "/plugin-main.php", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (6137, 390, "weautomusic_register_settings", "/plugin-main.php", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (6138, 390, "weautomusic_validate_options", "/plugin-main.php", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (6139, 390, "add_wexpand_automusic_options_framwrork", "/plugin-main.php", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (6140, 390, "wexpand_automusic_options_framwrork", "/plugin-main.php", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (6141, 390, "wp_expand_autoplay_music_all_files", "/plugin-main.php", now(), now());

insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (3557, 390, "wp_footer", "'append_music_to_body'", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (3558, 390, "admin_menu", "'add_wexpand_automusic_options_framwrork'", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (3559, 390, "admin_init", "'weautomusic_register_settings'", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (3560, 390, "init", "'wp_expand_autoplay_music_jquery'", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (3561, 390, "wp_enqueue_scripts", "'wp_expand_autoplay_music_all_files'", 10, now(), now());
