CREATE TABLE host_deltas (
    id INT NOT NULL PRIMARY KEY DEFAULT (nextval('deltas')),
    change_id INTEGER NOT NULL,
    host_id INTEGER NOT NULL,
    name VARCHAR,
    new INTEGER,
    FOREIGN KEY(change_id) REFERENCES changes(id) ON DELETE CASCADE,
    FOREIGN KEY(host_id) REFERENCES hosts(id) ON DELETE CASCADE
);

CREATE TRIGGER
    host_deltas_ai_1
AFTER INSERT ON
    host_deltas
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_id,
        NEW.host_id,
        NEW.name
    );

    UPDATE
        changes
    SET
        ucount = ucount + 1
    WHERE
        id = NEW.change_id
    ;

    UPDATE
        topics
    SET
        last_change_id = NEW.change_id
    WHERE
        id = NEW.host_id
    ;

    UPDATE
        changes_pending
    SET
        terms = terms || (
            SELECT
                '-' || x'0A'
                || CASE WHEN
                    NEW.new
                THEN
                    '  _: host' || x'0A'
                ELSE
                    '  _: host_delta' || x'0A'
                    || '  host_uuid: ' || topics.uuid || x'0A'
                END
                || '  name: ' || COALESCE(NEW.name,'~') || x'0A'
                || CASE WHEN
                    NEW.new
                THEN
                    '  topic_uuid: ' || topics.uuid || x'0A'
                ELSE
                    ''
                END
            FROM
                topics
            WHERE
                topics.id = NEW.host_id
        )
    WHERE
        change_id = NEW.change_id
    ;

/*
    INSERT INTO
        entity_related_changes(
            entity_id,
            change_id
        )
    VALUES (
        NEW.host_id,
        NEW.change_id
    );
*/

END;
