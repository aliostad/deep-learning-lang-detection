insert into plugins (id, name, testedUpTo, stableTag, requiresAtLeast, created, modified) values (999, "Plugin Name", "4.1", "4.3", "3.8", now(), now());

insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (92291, 999, "ContentArtDirection", "content_art_direction_save_meta", "/content-art-direction.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (92292, 999, "ContentArtDirection", "init_content_art_direction", "/content-art-direction.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (92293, 999, "ContentArtDirection", "content_art_direction_append_css", "/content-art-direction.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (92294, 999, "ContentArtDirection", "__construct", "/content-art-direction.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (92295, 999, "ContentArtDirection", "content_art_direction_meta", "/content-art-direction.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (92296, 999, "ContentArtDirection", "content_art_direction_append_js", "/content-art-direction.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (92297, 999, "ContentArtDirection", "content_art_direction_add_admin_ui", "/content-art-direction.php", now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (10941, 999, "init", "array(&$this,'init_content_art_direction')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (10942, 999, "wp_footer", "array(&$this,'content_art_direction_append_js')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (10943, 999, "add_meta_boxes", "array(&$this,'content_art_direction_meta')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (10944, 999, "save_post", "array(&$this,'content_art_direction_save_meta')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (10945, 999, "wp_head", "array(&$this,'content_art_direction_append_css')", 10, now(), now());
