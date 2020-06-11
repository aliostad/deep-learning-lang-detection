
INSERT INTO Reader.Category (categoryId, title)
SELECT
	id AS categoryId,
	title AS title
FROM ttrss_feed_categories;

INSERT INTO Reader.Feed (feedId, categoryId, url, title, frequency, isEnabled, dateChecked)
SELECT
	id AS feedId,
	cat_id AS categoryId,
	feed_url AS url,
	title AS title,
	IF(update_interval >= 0, update_interval, 0) AS frequency,
	(update_interval >= 0) AS isEnabled,
	last_updated AS dateChecked
FROM ttrss_feeds;

INSERT INTO Reader.Entry (entryId, feedId, externalId, url, title, dateUpdated, dateCreated, isMarked, isRead, dateReadLast)
SELECT
	ue.int_id AS entryId,
	ue.feed_id AS feedId,
	e.guid AS externalId,
	e.link AS url,
	e.title AS title,
	e.updated AS dateUpdated,
	IF(ue.last_read IS NOT NULL AND ue.last_read < e.date_entered, ue.last_read, e.date_entered) AS dateCreated,
	ue.marked AS isMarked,
	NOT ue.unread AS isRead,
	IFNULL(ue.last_read, 0) AS dateReadLast
FROM ttrss_entries AS e
	JOIN ttrss_user_entries AS ue ON (ue.ref_id = e.id)
WHERE ue.feed_id IS NOT NULL;

INSERT INTO Reader.EntryContent (entryId, content, dateUpdated, dateCreated)
SELECT
	ue.int_id AS entryId,
	e.content AS content,
	e.updated AS dateUpdated,
	IF(ue.last_read IS NOT NULL AND ue.last_read < e.date_entered, ue.last_read, e.date_entered) AS dateCreated
FROM ttrss_entries AS e
	JOIN ttrss_user_entries AS ue ON (ue.ref_id = e.id)
WHERE ue.feed_id IS NOT NULL;
