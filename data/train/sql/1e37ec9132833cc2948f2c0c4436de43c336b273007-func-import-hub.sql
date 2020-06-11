CREATE TABLE func_import_hub(
    change_uuid VARCHAR(40) NOT NULL,
    topic_uuid VARCHAR(40) NOT NULL,
    name VARCHAR(128) NOT NULL
);

CREATE TRIGGER
    func_import_hub_bi_1
BEFORE INSERT ON
    func_import_hub
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_uuid,
        NEW.topic_uuid,
        NEW.name
    );

    INSERT INTO
        func_new_hub(
            change_id,
            id,
            name
        )
    SELECT
        c.id,
        t.id,
        NEW.name
    FROM
        changes c
    INNER JOIN
        topics t
    ON
        t.uuid = NEW.topic_uuid
    WHERE
        c.uuid = NEW.change_uuid
    ;

    SELECT RAISE(IGNORE);
END;
