ALTER TABLE `libraries` DROP `library_template_id`;

ALTER TABLE `libraries` ADD `library_bgcolor` VARCHAR( 100 ) NOT NULL DEFAULT '606060' AFTER `library_domain_name` ,
ADD `library_content_bgcolor` VARCHAR( 100 ) NOT NULL DEFAULT 'FFFFFF' AFTER `library_bgcolor` ,
ADD `library_nav_bgcolor` VARCHAR( 100 ) NOT NULL DEFAULT '3F3F3F' AFTER `library_content_bgcolor` ,
ADD `library_text_color` VARCHAR( 100 ) NOT NULL DEFAULT '666666' AFTER `library_nav_bgcolor` ,
ADD `library_links_color` VARCHAR( 100 ) NOT NULL DEFAULT '666666' AFTER `library_text_color` ,
ADD `library_links_hover_color` VARCHAR( 100 ) NOT NULL DEFAULT '000000' AFTER `library_links_color` ,
ADD `library_navlinks_color` VARCHAR( 100 ) NOT NULL DEFAULT 'FFFFFF' AFTER `library_links_hover_color` ,
ADD `library_navlinks_hover_color` VARCHAR( 100 ) NOT NULL DEFAULT 'FFFFFF' AFTER `library_navlinks_color`;

DROP TABLE `library_templates`;