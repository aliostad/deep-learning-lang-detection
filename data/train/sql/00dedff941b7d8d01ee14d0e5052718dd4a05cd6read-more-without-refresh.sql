insert into plugins (id, name, testedUpTo, stableTag, requiresAtLeast, created, modified) values (3494, "Read More Without Refresh", "4.1.1", "0.1", "3.0.1", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (63540, 3494, "read_javascript", "/index.php", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (63541, 3494, "read_main", "/index.php", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (63542, 3494, "read_register_shortcodes", "/index.php", now(), now());

insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (38235, 3494, "wp_head", "'read_javascript'", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (38236, 3494, "init", "'read_register_shortcodes'", 10, now(), now());
