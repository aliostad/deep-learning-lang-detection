DROP TABLE IF EXISTS for_read_msg;

CREATE TABLE IF NOT EXISTS for_read_msg (
		id					BIGINT UNSIGNED AUTO_INCREMENT NOT NULL,
        reader_id			BIGINT UNSIGNED NOT NULL,
        author_id	 		BIGINT UNSIGNED NOT NULL,
        message_id			BIGINT UNSIGNED NOT NULL,
        forward_point		BIGINT UNSIGNED NOT NULL,
        creation_date		DATETIME,
        PRIMARY KEY (id)
)ENGINE=InnoDB;
-- used by Client and Server

ALTER TABLE for_read_msg ADD INDEX for_message_reader_id_idx (reader_id);
ALTER TABLE for_read_msg ADD INDEX for_message_author_id_idx (author_id);
ALTER TABLE for_read_msg ADD INDEX for_message_message_id_idx (message_id);

GRANT ALL PRIVILEGES ON for_read_msg TO PUBLIC;
/*


*/