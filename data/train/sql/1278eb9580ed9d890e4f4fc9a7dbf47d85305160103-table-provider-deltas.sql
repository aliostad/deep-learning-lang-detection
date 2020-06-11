CREATE TABLE provider_deltas (
    id INT NOT NULL PRIMARY KEY DEFAULT (nextval('deltas')),
    change_id INTEGER NOT NULL,
    provider_id INTEGER NOT NULL,
    name VARCHAR,
    new INTEGER,
    FOREIGN KEY(change_id) REFERENCES changes(id) ON DELETE CASCADE,
    FOREIGN KEY(provider_id) REFERENCES providers(id) ON DELETE CASCADE
);

CREATE TRIGGER
    provider_deltas_ai_1
AFTER INSERT ON
    provider_deltas
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_id,
        NEW.provider_id,
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
        id = NEW.provider_id
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
                    '  _: provider' || x'0A'
                ELSE
                    '  _: provider_delta' || x'0A'
                    || '  provider_uuid: ' || topics.uuid || x'0A'
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
                topics.id = NEW.provider_id
        )
    WHERE
        change_id = NEW.change_id
    ;

    INSERT INTO
        entity_related_changes(
            entity_id,
            change_id
        )
    VALUES (
        NEW.provider_id,
        NEW.change_id
    );

END;
