CREATE TABLE func_import_project_delta(
    change_uuid VARCHAR(40) NOT NULL,
    project_uuid VARCHAR(40) NOT NULL,
    parent_uuid VARCHAR(40),
    project_status_uuid VARCHAR(40),
    hub_uuid VARCHAR(40),
    name VARCHAR(40),
    title VARCHAR(1024)
);


CREATE TRIGGER
    func_import_project_delta_bi_1
BEFORE INSERT ON
    func_import_project_delta
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_uuid,
        NEW.project_uuid,
        NEW.parent_uuid,
        NEW.project_status_uuid,
        NEW.hub_uuid,
        NEW.name,
        NEW.title
    );

    INSERT INTO
        func_update_project(
            change_id,
            id,
            parent_id,
            project_status_id,
            hub_id,
            name,
            title
        )
    SELECT
        c.id,
        projects.id,
        parents.id,
        project_status.id,
        hubs.id,
        NEW.name,
        NEW.title
    FROM
        topics AS projects
    INNER JOIN
        changes c
    ON
        c.uuid = NEW.change_uuid
    LEFT JOIN
        topics AS parents
    ON
        parents.uuid = NEW.parent_uuid
    LEFT JOIN
        topics AS project_status
    ON
        project_status.uuid = NEW.project_status_uuid
    LEFT JOIN
        topics AS hubs
    ON
        hubs.uuid = NEW.hub_uuid
    WHERE
        projects.uuid = NEW.project_uuid
    ;

    SELECT RAISE(IGNORE);
END;
