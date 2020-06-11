CREATE TABLE change_deltas (
    id INT NOT NULL PRIMARY KEY DEFAULT (nextval('deltas')),
    change_id INTEGER NOT NULL UNIQUE,
    new INTEGER,
    action_format VARCHAR NOT NULL,
    action_topic_id_1 INTEGER,
    action_topic_id_2 INTEGER,
    FOREIGN KEY(change_id) REFERENCES changes(id) ON DELETE CASCADE,
    FOREIGN KEY(action_topic_id_1) REFERENCES topics(id)
        ON DELETE CASCADE,
    FOREIGN KEY(action_topic_id_2) REFERENCES topics(id)
        ON DELETE CASCADE
);

CREATE TRIGGER
    change_deltas_ai_1
AFTER INSERT ON
    change_deltas
FOR EACH ROW WHEN
    NEW.new = 1
BEGIN

    SELECT debug(
        'TRIGGER change_deltas_ai_1',
        NEW.change_id,
        NEW.action_topic_id_1,
        NEW.action_topic_id_2
    );

    UPDATE
        changes
    SET
        ucount = ucount + 1,
        action = (
            SELECT
                printf(NEW.action_format, t1.id, t2.id)
            FROM
                (SELECT 1)
            LEFT JOIN
                topics t1
            ON
                t1.id = NEW.action_topic_id_1
            LEFT JOIN
                topics t2
            ON
                t2.id = NEW.action_topic_id_2
        )
    WHERE
        id = NEW.change_id
    ;


    UPDATE
        changes_pending
    SET
        terms = terms || (
            SELECT
                '-' || x'0A'
                || '  _: change_delta' || x'0A'
                || CASE WHEN
                    instr(NEW.action_format, ' ')
                THEN
                    '  action_format: ''' || NEW.action_format || '''' || x'0A'
                ELSE
                    '  action_format: ' 
                    || COALESCE(NEW.action_format,'~') || x'0A'
                END
                || '  action_topic_uuid_1: '
                || COALESCE(t1.uuid, '~') || x'0A'
                || '  action_topic_uuid_2: '
                || COALESCE(t2.uuid, '~') || x'0A'
            FROM
                (SELECT 1)
            LEFT JOIN
                topics t1
            ON
                t1.id = NEW.action_topic_id_1
            LEFT JOIN
                topics t2
            ON
                t2.id = NEW.action_topic_id_2
        )
    WHERE
        change_id = NEW.change_id
    ;

END;
