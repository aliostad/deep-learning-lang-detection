insert into plugins (id, name, testedUpTo, stableTag, requiresAtLeast, created, modified) values (2693, "Menu Email Antispam", "4.1", "1.0.0", "3.0.1", now(), now());
insert into functions (id, plugin_id, function_name, function_loc, created, modified) values (49116, 2693, "ruandre_menu_email_antispam", "/menu-email-antispam.php", now(), now());


insert into filters (id, plugin_id, tag_name, filter_callback, filter_priority, created, modified) values (9759, 2693, "nav_menu_link_attributes", "'ruandre_menu_email_antispam'", 10, now(), now());