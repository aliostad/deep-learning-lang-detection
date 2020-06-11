CREATE TABLE func_new_entity(
    change_id INTEGER NOT NULL,
    id INTEGER NOT NULL,
    contact_id INTEGER,
    default_contact_method_id INTEGER,
    name VARCHAR NOT NULL
);


CREATE TRIGGER
    func_new_entity_bi_1
BEFORE INSERT ON
    func_new_entity
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_id,
        NEW.id,
        NEW.contact_id,
        NEW.default_contact_method_id,
        NEW.name
    );

    INSERT INTO entities(
        id,
        contact_id,
        default_contact_method_id,
        name
    )
    VALUES(
        NEW.id,
        COALESCE(NEW.contact_id,-1),
        COALESCE(NEW.default_contact_method_id,-1),
        NEW.name
    );

    INSERT INTO
        entity_deltas(
            change_id,
            entity_id,
            contact_id,
            default_contact_method_id,
            new,
            name
        )
    VALUES(
        NEW.change_id,
        NEW.id,
        NEW.contact_id,
        NEW.default_contact_method_id,
        1,
        NEW.name
    );

    SELECT RAISE(IGNORE);
END;
