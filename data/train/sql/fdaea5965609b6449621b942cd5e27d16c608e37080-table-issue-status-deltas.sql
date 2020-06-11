CREATE TABLE issue_status_deltas (
    id INT NOT NULL PRIMARY KEY DEFAULT (nextval('deltas')),
    change_id INTEGER NOT NULL,
    issue_status_id INTEGER NOT NULL,
    new INTEGER,
    status VARCHAR,
    rank INTEGER,
    def INTEGER,
    UNIQUE(change_id,issue_status_id), -- one change per change
    FOREIGN KEY(change_id) REFERENCES changes(id) ON DELETE CASCADE
    FOREIGN KEY(issue_status_id) REFERENCES issue_status(id) ON DELETE CASCADE,
    CONSTRAINT def_constraint CHECK (
        def = 1 OR def IS NULL
    )
);

CREATE TRIGGER
    issue_status_deltas_ai_1
AFTER INSERT ON
    issue_status_deltas
FOR EACH ROW
BEGIN
    
    SELECT debug(
        NEW.change_id,
        NEW.issue_status_id,
        NEW.status,
        NEW.rank,
        NEW.def
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
        id = NEW.issue_status_id
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
                    '  _: issue_status' || x'0A'
                ELSE
                    '  _: issue_status_delta' || x'0A'
                END
                || '  def: ' || COALESCE(NEW.def, '~') || x'0A'
                || CASE WHEN
                    NEW.new
                THEN
                    '  project_uuid: ' || p.uuid || x'0A'
                ELSE
                    '  issue_status_uuid: ' || topics.uuid || x'0A'
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
                issue_status ist
            ON
                ist.id = NEW.issue_status_id
            INNER JOIN
                topics p
            ON
                p.id = ist.project_id
            WHERE
                topics.id = NEW.issue_status_id
        )
    WHERE
        change_id = NEW.change_id
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
        issue_status
    WHERE
        id = NEW.issue_status_id
    ;

    INSERT OR IGNORE INTO
        issue_status_tomerge(issue_status_id)
    VALUES
        (NEW.issue_status_id)
    ;

    UPDATE
        issue_status_tomerge
    SET
        status = status + (NEW.status IS NOT NULL),
        rank   = rank + (NEW.rank IS NOT NULL),
        def    = def + (NEW.def IS NOT NULL)
    WHERE
        issue_status_id = NEW.issue_status_id
    ;

END;


CREATE TRIGGER
    issue_status_deltas_ad_1
AFTER DELETE ON
    issue_status_deltas
FOR EACH ROW
BEGIN

    SELECT debug(
        OLD.change_id,
        OLD.issue_status_id,
        OLD.status,
        OLD.rank,
        OLD.def
    );

    INSERT OR IGNORE INTO
        issue_status_tomerge(issue_status_id)
    VALUES
        (OLD.issue_status_id)
    ;

    UPDATE
        issue_status_tomerge
    SET
        status = status + (OLD.status IS NOT NULL),
        rank   = rank + (OLD.rank IS NOT NULL),
        def    = def + (OLD.def IS NOT NULL)
    WHERE
        issue_status_id = OLD.issue_status_id
    ;

END;
