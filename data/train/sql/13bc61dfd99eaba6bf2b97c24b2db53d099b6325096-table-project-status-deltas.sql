CREATE TABLE project_status_deltas (
    id INT NOT NULL PRIMARY KEY DEFAULT (nextval('deltas')),
    change_id INTEGER NOT NULL,
    project_status_id INTEGER NOT NULL,
    new INTEGER,
    status VARCHAR,
    rank INTEGER,
    UNIQUE(change_id,project_status_id), -- one change per change
    FOREIGN KEY(change_id) REFERENCES changes(id) ON DELETE CASCADE
    FOREIGN KEY(project_status_id) REFERENCES project_status(id)
        ON DELETE CASCADE
);

CREATE TRIGGER
    project_status_deltas_ai_1
AFTER INSERT ON
    project_status_deltas
FOR EACH ROW
BEGIN

    SELECT debug(
        'TRIGGER project_status_deltas_ai_1',
        NEW.id,
        NEW.change_id,
        NEW.project_status_id,
        NEW.status,
        NEW.rank
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
        id = NEW.project_status_id
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
                    '  _: project_status' || x'0A'
                    || '  project_uuid: ' || p.uuid || x'0A'
                ELSE
                    '  _: project_status_delta' || x'0A'
                    || '  project_status_uuid: ' || topics.uuid || x'0A'
                END
                || '  rank: ' || COALESCE(NEW.rank, '~') || x'0A'
                || CASE WHEN
                    NEW.status = '-'
                THEN
                    '  status: ''-''' || x'0A'
                ELSE
                    '  status: ' || COALESCE(NEW.status, '~') || x'0A'
                END
                || CASE WHEN
                    NEW.new
                THEN
                    '  topic_uuid: ' || topics.uuid || x'0A'
                ELSE
                    ''
                END
            FROM
                topics
            INNER JOIN
                project_status ps
            ON
                ps.id = NEW.project_status_id
            INNER JOIN
                topics p
            ON
                p.id = ps.project_id
            WHERE
                topics.id = NEW.project_status_id
        )
    WHERE
        change_id = NEW.change_id
    ;

    INSERT OR IGNORE INTO
        project_status_tomerge(project_status_id)
    VALUES
        (NEW.project_status_id)
    ;

    INSERT INTO
        project_changes(
            change_id,
            project_id
        )
    SELECT
        NEW.change_id,
        project_id
    FROM
        project_status
    WHERE
        id = NEW.project_status_id
    ;

    UPDATE
        project_status_tomerge
    SET
        status = status + (NEW.status IS NOT NULL),
        rank   = rank + (NEW.rank IS NOT NULL)
    WHERE
        project_status_id = NEW.project_status_id
    ;

END;


CREATE TRIGGER
    project_status_deltas_ad_1
AFTER DELETE ON
    project_status_deltas
FOR EACH ROW
BEGIN

    SELECT debug(
        'TRIGGER project_status_deltas_ad_1',
        OLD.change_id,
        OLD.project_status_id,
        OLD.status,
        OLD.rank
    );

    INSERT OR IGNORE INTO
        project_status_tomerge(project_status_id)
    VALUES
        (OLD.project_status_id)
    ;

    UPDATE
        project_status_tomerge
    SET
        status = status + (OLD.status IS NOT NULL),
        rank   = rank + (OLD.rank IS NOT NULL)
    WHERE
        project_status_id = OLD.project_status_id
    ;

END;
