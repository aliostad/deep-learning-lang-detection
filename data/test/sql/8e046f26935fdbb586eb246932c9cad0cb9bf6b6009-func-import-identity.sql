CREATE TABLE func_import_identity(
    change_uuid VARCHAR(40) NOT NULL,
    entity_uuid VARCHAR(40) NOT NULL,
    shortname VARCHAR
);

CREATE TRIGGER
    func_import_identity_bi_1
BEFORE INSERT ON
    func_import_identity
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_uuid,
        NEW.entity_uuid,
        NEW.shortname
    );

    INSERT INTO
        func_new_identity(
            change_id,
            id,
            shortname
        )
    SELECT
        c.id,
        e.id,
        NEW.shortname
    FROM
        changes c
    INNER JOIN
        topics e
    ON
        e.uuid = NEW.entity_uuid
    WHERE
        c.uuid = NEW.change_uuid
    ;

    SELECT RAISE(IGNORE);
END;
