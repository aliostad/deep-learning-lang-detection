CREATE TABLE task_deltas (
    id INT NOT NULL PRIMARY KEY DEFAULT (nextval('deltas')),
    change_id INTEGER NOT NULL,
    task_id INTEGER NOT NULL,
    new INTEGER,
    task_status_id INTEGER,
    title VARCHAR(1024),
    UNIQUE(change_id,task_id), -- one change per change
    FOREIGN KEY(change_id) REFERENCES changes(id) ON DELETE CASCADE,
    FOREIGN KEY(task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    FOREIGN KEY(task_status_id) REFERENCES task_status(id) ON DELETE CASCADE
);

CREATE TRIGGER
    task_deltas_ai_2
AFTER INSERT ON
    task_deltas
FOR EACH ROW WHEN
    NEW.task_status_id IS NOT NULL
BEGIN
    -- This catches the current change project for the task
    INSERT INTO
        project_related_changes(
            project_id,
            real_project_id,
            change_id
        )
    SELECT
        ts.project_id,
        ts.project_id,
        NEW.change_id
    FROM
        task_status ts
    WHERE
        ts.id = NEW.task_status_id
    ;

END;

CREATE TRIGGER
    task_deltas_ai_1
AFTER INSERT ON
    task_deltas
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_id,
        NEW.task_id,
        NEW.task_status_id,
        NEW.title
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
        id = NEW.task_id
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
                    '  _: task' || x'0A'
                ELSE
                    '  _: task_delta' || x'0A'
                END
                || '  task_status_uuid: '
                || COALESCE(status.uuid, '~') || x'0A'
                || CASE WHEN
                    NEW.new
                THEN
                    ''
                ELSE
                    '  task_uuid: ' || topics.uuid || x'0A'
                END
                || CASE WHEN
                    instr(NEW.title, ' ')
                THEN
                    '  title: ''' || NEW.title || '''' || x'0A'
                ELSE
                    '  title: ' 
                    || COALESCE(NEW.title,'~') || x'0A'
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
            LEFT JOIN
                topics as status
            ON
                status.id = NEW.task_status_id
            WHERE
                topics.id = NEW.task_id
        )
    WHERE
        change_id = NEW.change_id
    ;

    -- This catches the current project for the task
    INSERT INTO
        project_related_changes(
            project_id,
            real_project_id,
            change_id
        )
    SELECT
        ts.project_id,
        ts.project_id,
        NEW.change_id
    FROM
        tasks t
    INNER JOIN
        task_status ts
    ON
        ts.id = t.task_status_id
    WHERE
        t.id = NEW.task_id
    ;

    INSERT OR IGNORE INTO
        tasks_tomerge(task_id)
    VALUES
        (NEW.task_id)
    ;

    UPDATE
        tasks_tomerge
    SET
        task_status_id = task_status_id + (NEW.task_status_id IS NOT NULL),
        title    = title + (NEW.title IS NOT NULL)
    WHERE
        task_id = NEW.task_id
    ;

END;


CREATE TRIGGER
    task_deltas_ad_1
AFTER DELETE ON
    task_deltas
FOR EACH ROW
BEGIN

    SELECT debug(
        OLD.change_id,
        OLD.task_id,
        OLD.task_status_id,
        OLD.title
    );

    INSERT OR IGNORE INTO
        tasks_tomerge(task_id)
    VALUES
        (OLD.task_id)
    ;

    UPDATE
        tasks_tomerge
    SET
        task_status_id = task_status_id + (OLD.task_status_id IS NOT NULL),
        title    = title + (OLD.title IS NOT NULL)
    WHERE
        task_id = OLD.task_id
    ;

END;

