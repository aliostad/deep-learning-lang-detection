#DROP TABLE IF EXISTS blog_posts;
CREATE TABLE IF NOT EXISTS blog_posts
(
	id INTEGER UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

	title VARCHAR(255),

	url VARCHAR(255),

	summary VARCHAR(200),

	content TEXT,

	created DATETIME,
	modified DATETIME
);

#DROP TABLE IF EXISTS blog_tags;
CREATE TABLE IF NOT EXISTS blog_tags
(
	id INTEGER UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	tag VARCHAR(100) NOT NULL,
	created DATETIME NOT NULL,
	modified DATETIME NOT NULL
);


#DROP TABLE IF EXISTS blog_posts_blog_tags;
CREATE TABLE IF NOT EXISTS blog_posts_blog_tags
(
	id INTEGER UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	blog_post_id INTEGER UNSIGNED NOT NULL,
	blog_tag_id INTEGER UNSIGNED NOT NULL
);

ALTER TABLE blog_posts_blog_tags RENAME blog_posts_tags;

ALTER TABLE blog_posts ADD nav_topic BOOL DEFAULT FALSE;
ALTER TABLE blog_posts ADD parent_id INTEGER UNSIGNED;
ALTER TABLE blog_posts_tags CHANGE blog_post_id post_id INTEGER UNSIGNED, CHANGE blog_tag_id tag_id INTEGER UNSIGNED;

ALTER TABLE blog_tags CHANGE tag name VARCHAR(100);

ALTER TABLE blog_posts ADD draft BOOL DEFAULT FALSE;

ALTER TABLE blog_posts CHANGE nav_topic nav_topic VARCHAR(32);


###########################################
#DROP TABLE IF EXISTS blog_topics;
CREATE TABLE IF NOT EXISTS blog_topics
(
	id INTEGER UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

	title VARCHAR(200),
	url VARCHAR(64),
	user_id INTEGER UNSIGNED,

	content TEXT,
	ix INTEGER UNSIGNED,
	draft BOOL DEFAULT FALSE, # So can shut off experimental stuff...

	created DATETIME,
	modified DATETIME
);

ALTER TABLE blog_posts ADD blog_topic_id INTEGER UNSIGNED;
ALTER TABLE blog_posts ADD user_id INTEGER UNSIGNED;


#####################################
#DROP TABLE IF EXISTS blog_subscribers;
CREATE TABLE IF NOT EXISTS blog_subscribers
(
	id INTEGER UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

	email VARCHAR(64),
	name VARCHAR(64),

	confirmed BOOL DEFAULT FALSE,

	created DATETIME,
	modified DATETIME
);
