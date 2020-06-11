CREATE TABLE func_import_entity_contact_method(
    change_uuid VARCHAR(40) NOT NULL,
    topic_uuid VARCHAR(40) NOT NULL,
    entity_uuid VARCHAR(40) NOT NULL,
    method VARCHAR NOT NULL,
    mvalue VARCHAR NOT NULL
);


CREATE TRIGGER
    func_import_entity_contact_method_bi_1
BEFORE INSERT ON
    func_import_entity_contact_method
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_uuid,
        NEW.topic_uuid,
        NEW.entity_uuid,
        NEW.method,
        NEW.mvalue
    );

    INSERT INTO
        func_new_entity_contact_method(
            change_id,
            id,
            entity_id,
            method,
            mvalue
        )
    SELECT
        c.id,
        t.id,
        e.id,
        NEW.method,
        NEW.mvalue
    FROM
        changes c
    INNER JOIN
        topics t
    ON
        t.uuid = NEW.topic_uuid
    INNER JOIN
        topics e
    ON
        e.uuid = NEW.entity_uuid
    WHERE
        c.uuid = NEW.change_uuid
    ;

    SELECT RAISE(IGNORE);
END;
