CREATE TABLE func_import_entity(
    change_uuid VARCHAR(40) NOT NULL,
    topic_uuid VARCHAR(40) NOT NULL,
    contact_uuid VARCHAR(40),
    default_contact_method_uuid VARCHAR(40),
    name VARCHAR NOT NULL
);

CREATE TRIGGER
    func_import_entity_bi_1
BEFORE INSERT ON
    func_import_entity
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_uuid,
        NEW.topic_uuid,
        NEW.contact_uuid,
        NEW.default_contact_method_uuid,
        NEW.name
    );

    INSERT INTO
        func_new_entity(
            change_id,
            id,
            contact_id,
            default_contact_method_id,
            name
        )
    SELECT
        c.id,
        t.id,
        ct.id,
        ecm.id,
        NEW.name
    FROM
        changes c
    INNER JOIN
        topics t
    ON
        t.uuid = NEW.topic_uuid
    LEFT JOIN
        topics ct
    ON
        ct.uuid = NEW.contact_uuid
    LEFT JOIN
        topics ecm
    ON
        ecm.uuid = NEW.default_contact_method_uuid
    WHERE
        c.uuid = NEW.change_uuid
    ;

    SELECT RAISE(IGNORE);
END;
