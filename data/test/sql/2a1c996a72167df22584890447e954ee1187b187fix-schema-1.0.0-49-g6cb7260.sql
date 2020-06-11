
/* counts
 * Holds the number of read and unread items in each feed. This is for
 * caching, really, since counting the items takes a long time (seconds).
 */
CREATE TABLE counts (
	feed_id		INT		NOT NULL,
	total		INT,
	num_read	INT,
	PRIMARY KEY(feed_id)
)
DEFAULT CHARSET=utf8;

/* add_feed
 * Trigger to add a row to `counts` when we add a new feed.
 */
CREATE TRIGGER add_feed
AFTER INSERT ON feeds
FOR EACH ROW
	INSERT INTO counts
	SET	feed_id = NEW.id,
		total = 0,
		num_read = 0;

/* drop_feed
 * Trigger: when we delete a feed, delete its row in `counts`.
 */
CREATE TRIGGER drop_feed
AFTER DELETE ON feeds
FOR EACH ROW
	DELETE FROM counts
	WHERE	feed_id = OLD.id;

/* add_item
 * When we add a new item, it's initially unread. Increment `counts.total`.
 * '
 */
CREATE TRIGGER add_item
AFTER INSERT ON items
FOR EACH ROW
	UPDATE	counts
	SET	total = total + 1
	WHERE	feed_id = NEW.feed_id;

/* del_item
 * When we delete an item, decrement `counts.total`, and also is_read,
 * but only if the item being deleted was read.
 */
DELIMITER $$
CREATE TRIGGER del_item
AFTER DELETE ON items
FOR EACH ROW
    BEGIN
        UPDATE counts
        SET total = total - 1,
	    num_read = num_read - IF(OLD.is_read, 1, 0)
	WHERE counts.feed_id = OLD.feed_id;
    END$$
DELIMITER ;

/* update_item
 * Update `counts` when an item gets updated.
 * The UPDATE here uses a trick: the fact that booleans are also integers:
 * OLD.is_read	NEW.is_read	=> counts.num_read
 * 0		0		+0
 * 0		1		+1
 * 1		0		-1
 * 1		1		+0
 */
CREATE TRIGGER update_item
AFTER UPDATE ON items
FOR EACH ROW
	UPDATE counts
	SET num_read = num_read + NEW.is_read - OLD.is_read
	WHERE counts.feed_id = OLD.feed_id;

# Populate the `counts` table with initial data
DELETE FROM counts;
INSERT INTO counts (feed_id, total, num_read)
SELECT feeds.id AS feed_id,
    COUNT(items.id) AS total,
    SUM(IF(is_read,1,0)) AS num_read
FROM feeds
LEFT JOIN items
   ON items.feed_id = feeds.id
GROUP BY feeds.id;
