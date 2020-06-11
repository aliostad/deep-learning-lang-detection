CREATE TABLE func_import_project(
    change_uuid VARCHAR(40) NOT NULL,
    topic_uuid VARCHAR(40) NOT NULL,
    parent_uuid VARCHAR(40),
    name VARCHAR(40) NOT NULL,
    title VARCHAR(1024) NOT NULL
);


CREATE TRIGGER
    func_import_project_bi_1
BEFORE INSERT ON
    func_import_project
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_uuid,
        NEW.topic_uuid,
        NEW.parent_uuid,
        NEW.name,
        NEW.title
    );

    INSERT INTO
        func_new_project(
            change_id,
            id,
            parent_id,
            name,
            title
        )
    SELECT
        c.id,
        t.id,
        p.id,
        NEW.name,
        NEW.title
    FROM
        changes c
    INNER JOIN
        topics t
    ON
        t.uuid = NEW.topic_uuid
    LEFT JOIN
        topics p
    ON
        p.uuid = NEW.parent_uuid
    WHERE
        c.uuid = NEW.change_uuid
    ;

    SELECT RAISE(IGNORE);
END;
