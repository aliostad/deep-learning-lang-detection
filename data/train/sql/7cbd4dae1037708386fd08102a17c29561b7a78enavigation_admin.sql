SQL Standard
CREATE TABLE kio_navigation_admin
(
	nav_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	nav_name VARCHAR(100) NOT NULL,
	nav_order TINYINT(2) UNSIGNED NOT NULL,
	nav_is_parent TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	nav_url VARCHAR(100),
	nav_inline_code VARCHAR(250),
	PRIMARY KEY (nav_id)
);

INSERT INTO scms_navigation (id, name, codename, static_id, sublink_for, url, _blank, css_id, position) VALUES
(1, "Strona glowna", "", "", "", "/", "", "", 1),
(2, "Ksiega gosci", "", "", "", "/guestbook.php", "", "", 2),
(3, "Rejestracja", "", "", "", "/registration.php", "", "", 3);
