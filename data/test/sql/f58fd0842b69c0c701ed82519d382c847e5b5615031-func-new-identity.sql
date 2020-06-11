CREATE TABLE func_new_identity(
    change_id INTEGER NOT NULL,
    id INTEGER NOT NULL DEFAULT (nextval('topics')),
    shortname VARCHAR
);


CREATE TRIGGER
    func_new_identity_bi_1
BEFORE INSERT ON
    func_new_identity
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_id,
        NEW.shortname,
        NEW.id
    );

    INSERT INTO identities(
        id,
        shortname
    )
    VALUES(
        NEW.id,
        NEW.shortname
    );

    INSERT INTO
        identity_deltas(
            change_id,
            identity_id,
            shortname,
            new
        )
    VALUES(
        NEW.change_id,
        NEW.id,
        NEW.shortname,
        1
    );

    /*
        Set changes.identity_id to this identity to trigger an entry in
        changes_pending.terms for identity_uuid.
    */

    UPDATE
        changes
    SET
        identity_id = NEW.id
    WHERE
        id = NEW.change_id AND identity_id = -1
    ;

    SELECT RAISE(IGNORE);
END;
