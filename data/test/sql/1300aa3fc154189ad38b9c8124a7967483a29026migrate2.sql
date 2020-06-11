CREATE TABLE daily (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	project_id INTEGER,
	timestamp timestamp,
	sloc INTEGER,
	floc DOUBLE,
	FOREIGN KEY(project_id) REFERENCES projects(id)
);

INSERT INTO daily (project_id, timestamp, sloc, floc) 
	SELECT c.project_id, c.timestamp, c.sloc, c.floc
	FROM (SELECT project_id, max(timestamp) as max_timestamp
		  FROM commits
	      WHERE sloc > 0 
	      GROUP BY project_id, DATE(timestamp, 'unixepoch')) x, commits c
	WHERE x.project_id = c.project_id AND
	      x.max_timestamp = c.timestamp;

CREATE TRIGGER insert_daily AFTER INSERT ON commits
WHEN new.sloc > 0
	AND 0 = (SELECT count() 
		FROM daily 
		WHERE DATE(timestamp, 'unixepoch') = DATE(new.timestamp, 'unixepoch')
			AND project_id = new.project_id)
BEGIN
	INSERT INTO daily (project_id, timestamp, sloc, floc) 
	VALUES (new.project_id, new.timestamp, new.sloc, new.floc);
END;

CREATE TRIGGER update_daily AFTER INSERT ON commits
WHEN new.sloc > 0
	AND new.timestamp > (SELECT timestamp
		FROM daily 
		WHERE DATE(timestamp, 'unixepoch') = DATE(new.timestamp, 'unixepoch')
			AND project_id = new.project_id)
BEGIN
	UPDATE DAILY SET timestamp = new.timestamp, sloc = new.sloc, floc = new.floc
	WHERE DATE(timestamp, 'unixepoch') = DATE(new.timestamp, 'unixepoch')
		AND project_id = new.project_id;
END;

CREATE TRIGGER update_its_own_delta AFTER INSERT ON commits
WHEN new.sloc > 0
	AND 0 < (SELECT count() FROM commits WHERE sha1 = new.parents AND sloc > 0)
BEGIN
	UPDATE commits SET 
		delta_sloc=sloc-(SELECT sloc FROM commits WHERE sha1 = new.parents),
		delta_floc=floc-(SELECT floc FROM commits WHERE sha1 = new.parents),
		delta_codefat=codefat-(SELECT codefat FROM commits WHERE sha1 = new.parents)
	WHERE sha1 = new.sha1;
END;

CREATE TRIGGER update_childrens_delta AFTER INSERT ON commits
WHEN new.sloc > 0
BEGIN
	UPDATE commits SET 
		delta_sloc=sloc-new.sloc,
		delta_floc=floc-new.floc,
		delta_codefat=codefat-new.codefat
	WHERE parents = new.sha1 and sloc > 0;
END;
