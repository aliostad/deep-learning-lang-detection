CREATE TABLE func_new_entity_contact_method(
    change_id INTEGER NOT NULL,
    id INTEGER NOT NULL DEFAULT (nextval('topics')),
    entity_id INTEGER NOT NULL,
    method VARCHAR NOT NULL,
    mvalue VARCHAR NOT NULL
);


CREATE TRIGGER
    func_new_entity_contact_method_bi_1
BEFORE INSERT ON
    func_new_entity_contact_method
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_id,
        NEW.id,
        NEW.entity_id,
        NEW.method,
        NEW.mvalue
    );


    INSERT INTO entity_contact_methods(
        id,
        entity_id,
        method,
        mvalue
    )
    VALUES(
        NEW.id,
        NEW.entity_id,
        NEW.method,
        NEW.mvalue
    );

    INSERT INTO
        entity_contact_method_deltas(
            change_id,
            entity_contact_method_id,
            new,
            method,
            mvalue
        )
    VALUES(
        NEW.change_id,
        NEW.id,
        1,
        NEW.method,
        NEW.mvalue
    );

    SELECT RAISE(IGNORE);
END;
