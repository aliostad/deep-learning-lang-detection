-- TODO should callers actually use func_update_entity?
CREATE TABLE func_update_identity(
    change_id INTEGER NOT NULL,
    id INTEGER NOT NULL,
    name VARCHAR,
    shortname VARCHAR,
    contact_id INTEGER,
    default_contact_method_id INTEGER
);

CREATE TRIGGER
    func_update_identity_bi_1
BEFORE INSERT ON
    func_update_identity
FOR EACH ROW BEGIN

    SELECT debug(
        NEW.id,
        NEW.change_id,
        NEW.name,
        NEW.shortname,
        NEW.contact_id,
        NEW.default_contact_method_id
    );

    INSERT INTO
        entity_deltas(
            change_id,
            entity_id,
            name,
            contact_id,
            default_contact_method_id
        )
    VALUES(
        NEW.change_id,
        NEW.id,
        NEW.name,
        NEW.contact_id,
        NEW.default_contact_method_id
    );

    INSERT INTO
        identity_deltas(
            change_id,
            identity_id,
            shortname
        )
    VALUES(
        NEW.change_id,
        NEW.id,
        NEW.shortname
    );

    SELECT RAISE(IGNORE);

END;
