insert into plugins (id, name, testedUpTo, stableTag, requiresAtLeast, created, modified) values (5175, "WP Flash", "4.1.1", "4.3", "2.0.0", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (89810, 5175, "wpFlashParseMacro", "/wp-flash.php", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (89811, 5175, "wpFlashInsertSwf", "/wp-flash.php", now(), now());


insert into filters (id, plugin_id, tag_name, filter_callback, filter_priority, created, modified) values (19190, 5175, "the_content", "'wpFlashInsertSwf'", 10, now(), now());
insert into filters (id, plugin_id, tag_name, filter_callback, filter_priority, created, modified) values (19191, 5175, "the_excerpt", "'wpFlashInsertSwf'", 10, now(), now());