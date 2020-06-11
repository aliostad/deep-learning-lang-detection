
INSERT INTO
	sites
(
	path
)
VALUES
(
	'english'
);

SET @site_id = LAST_INSERT_ID();

INSERT INTO
	nav
(
	site_id
	,path
	,title
)
VALUES
(
	@site_id
	,''
	,'Home'
); 

SET @nav_id = LAST_INSERT_ID();

INSERT INTO
	content
(
	nav_id
	,path
	,title
	,content
	,status
)
VALUES
(
	@nav_id
	,''
	,'Home'
	,'<p>Welcome!</p>'
	,'active'
);

UPDATE
	nav
SET
	content_id = LAST_INSERT_ID()
WHERE
	id = @nav_id;

INSERT INTO
	nav
(
	site_id
	,path
	,title
)
VALUES
(
	@site_id
	,'about'
	,'About'
);

SET @about_id = LAST_INSERT_ID();

INSERT INTO
	content
(
	nav_id
	,path
	,title
	,content
	,status
)
VALUES
(
	@about_id
	,'about-cap'
	,'About'
	,'<p>About Us</p>'
	,'active'
);

UPDATE
        nav
SET
        content_id = LAST_INSERT_ID()
WHERE
        id = @about_id;

INSERT INTO
	nav
(
	site_id
	,parent_id
	,path
	,title
)
VALUES
(
	@site_id
	,@about_id
	,'sapling'
	,'Sapling'
);

SET @sapling_id = LAST_INSERT_ID();

INSERT INTO
	content
(
	nav_id
	,path
	,title
	,content
	,status
)
VALUES
(
	@sapling_id
	,'sapling'
	,'Sapling'
	,'<p>About Sapling</p>'
	,'active'
);

UPDATE
        nav
SET
        content_id = LAST_INSERT_ID()
WHERE
        id = @sapling_id;
