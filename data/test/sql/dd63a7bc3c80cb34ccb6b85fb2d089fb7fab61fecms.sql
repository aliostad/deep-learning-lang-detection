CREATE TABLE sites (
    id serial NOT NULL PRIMARY KEY,
    path VARCHAR(255) UNIQUE,
    created TIMESTAMP DEFAULT NOW()
);

CREATE TABLE nav (
    id serial NOT NULL PRIMARY KEY,
    site_id int DEFAULT 1,
    parent_id INT DEFAULT 0,
    content_id INT DEFAULT NULL UNIQUE,
    title VARCHAR(255),
    path VARCHAR(255),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(255) DEFAULT 'active',
    UNIQUE(site_id, parent_id, path)
);

CREATE TABLE content (
    id serial NOT NULL PRIMARY KEY,
    nav_id INT DEFAULT 0,
    path VARCHAR(255),
    title VARCHAR(255),
    person_id INT,
    created TIMESTAMP DEFAULT NOW(),
    modified TIMESTAMP,
    description text,
    content text,
    status VARCHAR(255) DEFAULT 'new',
    UNIQUE(nav_id, path)
);

