CREATE TABLE func_new_issue_status(
    change_id INTEGER NOT NULL,
    id INTEGER NOT NULL DEFAULT (nextval('topics')),
    project_id INTEGER,
    status VARCHAR(40) NOT NULL,
    rank INTEGER NOT NULL,
    def INTEGER
);

CREATE TRIGGER
    func_new_issue_status_bi_1
BEFORE INSERT ON
    func_new_issue_status
FOR EACH ROW
BEGIN

    SELECT debug(
        'TRIGGER func_new_issue_status_bi_1',
        NEW.id,
        NEW.project_id,
        NEW.status,
        NEW.rank,
        NEW.def
    );

    INSERT INTO
        issue_status(
            id,
            project_id,
            status,
            rank,
            def
        )
    VALUES(
        NEW.id,
        NEW.project_id,
        NEW.status,
        NEW.rank,
        NEW.def
    );

    INSERT INTO
        issue_status_deltas(
            change_id,
            issue_status_id,
            new,
            status,
            rank,
            def
        )
    VALUES(
        NEW.change_id,
        NEW.id,
        1,
        NEW.status,
        NEW.rank,
        NEW.def
    );

    SELECT RAISE(IGNORE);
END;
