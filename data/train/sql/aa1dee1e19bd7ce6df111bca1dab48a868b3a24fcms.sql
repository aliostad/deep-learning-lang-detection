
CREATE TABLE sites (
    id SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    path VARCHAR(255) UNIQUE,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE nav (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    site_id SMALLINT UNSIGNED DEFAULT 1,
    parent_id INT UNSIGNED DEFAULT 0,
    content_id INT UNSIGNED DEFAULT NULL UNIQUE,
    title VARCHAR(255),
    path VARCHAR(255),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active','disabled') DEFAULT 'active',
    UNIQUE(site_id, parent_id, path)
);

CREATE TABLE content (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nav_id INT UNSIGNED DEFAULT 0,
    path VARCHAR(255),
    title VARCHAR(255),
    person_id INT UNSIGNED,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP,
    description text,
    content text,
    status ENUM('new','pending','active','disabled') DEFAULT 'new',
    UNIQUE(nav_id, path)
);

CREATE TABLE content_archive LIKE content;

CREATE TABLE redirects (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    old_url VARCHAR(255) UNIQUE,
    new_url text,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
