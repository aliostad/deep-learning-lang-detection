insert into plugins (id, name, testedUpTo, stableTag, requiresAtLeast, created, modified) values (449, "Batch Comment Spam Deletion", "4.1", "1.0.5", "3.6", now(), now());

insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (48205, 449, "PW_BCPD", "process_batch", "/batch-comment-spam-deletion.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (48206, 449, "PW_BCPD", "init", "/batch-comment-spam-deletion.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (48207, 449, "PW_BCPD", "admin_head", "/batch-comment-spam-deletion.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (48208, 449, "PW_BCPD", "processing_page", "/batch-comment-spam-deletion.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (48209, 449, "PW_BCPD", "comments_nav", "/batch-comment-spam-deletion.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (48210, 449, "PW_BCPD", "admin_notices", "/batch-comment-spam-deletion.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (48211, 449, "PW_BCPD", "text_domain", "/batch-comment-spam-deletion.php", now(), now());
insert into methods (id, plugin_id, class_name, method_name, method_loc, created, modified) values (48212, 449, "PW_BCPD", "admin_menu", "/batch-comment-spam-deletion.php", now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (4316, 449, "admin_head", "array('PW_BCPD','admin_head')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (4317, 449, "manage_comments_nav", "array('PW_BCPD','comments_nav')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (4318, 449, "admin_notices", "array('PW_BCPD','admin_notices')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (4319, 449, "admin_menu", "array('PW_BCPD','admin_menu')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (4320, 449, "plugins_loaded", "array('PW_BCPD','init')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (4321, 449, "admin_init", "array('PW_BCPD','process_batch')", 10, now(), now());
insert into hooks (id, plugin_id, hook_name, hook_callback, hook_priority, created, modified) values (4322, 449, "admin_init", "array('PW_BCPD','text_domain')", 10, now(), now());
