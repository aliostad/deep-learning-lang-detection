SQL Standard
CREATE TABLE kio_navigation
(
	nav_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nav_name VARCHAR(100) NOT NULL,
	nav_order TINYINT(2) UNSIGNED NOT NULL,
	nav_parent_id INT(10) UNSIGNED NOT NULL,
	nav_url VARCHAR(100),
	nav_inline VARCHAR(250),
);

INSERT INTO scms_navigation (id, name, codename, static_id, sublink_for, url, _blank, css_id, position) VALUES
(1, "Strona glowna", "", "", "", "/", "", "", 1),
(2, "Ksiega gosci", "", "", "", "/guestbook.php", "", "", 2),
(3, "Rejestracja", "", "", "", "/registration.php", "", "", 3);
