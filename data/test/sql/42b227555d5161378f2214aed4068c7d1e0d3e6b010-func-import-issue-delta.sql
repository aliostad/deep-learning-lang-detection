CREATE TABLE func_import_issue_delta(
    change_uuid VARCHAR(40) NOT NULL,
    issue_uuid VARCHAR(40),
    project_uuid VARCHAR(40),
    issue_status_uuid VARCHAR(40),
    title VARCHAR(1024)
);


CREATE TRIGGER
    func_import_issue_delta_bi_1
BEFORE INSERT ON
    func_import_issue_delta
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_uuid,
        NEW.issue_uuid,
        NEW.project_uuid,
        NEW.issue_status_uuid,
        NEW.title
    );

    INSERT INTO
        func_update_issue(
            change_id,
            id,
            project_id,
            issue_status_id,
            title
        )
    SELECT
        c.id,
        issues.id,
        projects.id,
        issue_status.id,
        NEW.title
    FROM
        (SELECT 1)
    INNER JOIN
        changes c
    ON
        c.uuid = NEW.change_uuid
    LEFT JOIN
        topics AS issues
    ON
        issues.uuid = NEW.issue_uuid
    LEFT JOIN
        topics AS projects
    ON
        projects.uuid = NEW.project_uuid
    LEFT JOIN
        topics AS issue_status
    ON
        issue_status.uuid = NEW.issue_status_uuid
    ;

    SELECT RAISE(IGNORE);
END;
