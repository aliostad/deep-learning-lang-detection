CREATE TABLE func_import_entity_delta(
    change_uuid VARCHAR(40) NOT NULL,
    entity_uuid VARCHAR(40) NOT NULL,
    name VARCHAR,
    contact_uuid VARCHAR(40),
    default_contact_method_uuid VARCHAR(40)
);

CREATE TRIGGER
    func_import_entity_delta_bi_1
BEFORE INSERT ON
    func_import_entity_delta
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_uuid,
        NEW.entity_uuid,
        NEW.name,
        NEW.contact_uuid,
        NEW.default_contact_method_uuid
    );

    INSERT INTO
        entity_deltas(
            change_id,
            entity_id,
            name,
            contact_id,
            default_contact_method_id
        )
    SELECT
        c.id,
        e.id,
        NEW.name,
        ct.id,
        dcm.id
        
    FROM
        topics e
    INNER JOIN
        changes c
    ON
        c.uuid = NEW.change_uuid
    LEFT JOIN
        topics ct
    ON
        ct.uuid = NEW.contact_uuid
    LEFT JOIN
        topics dcm
    ON
        dcm.uuid = NEW.default_contact_method_uuid
    WHERE
        e.uuid = NEW.entity_uuid
    ;

    SELECT RAISE(IGNORE);
END;
