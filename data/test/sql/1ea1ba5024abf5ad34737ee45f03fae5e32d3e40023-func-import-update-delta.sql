CREATE TABLE func_import_change_delta(
    change_uuid VARCHAR(40) NOT NULL,
    action_format VARCHAR NOT NULL,
    action_topic_uuid_1 VARCHAR(40),
    action_topic_uuid_2 VARCHAR(40)
);


CREATE TRIGGER
    func_import_change_delta_bi_1
BEFORE INSERT ON
    func_import_change_delta
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_uuid,
        NEW.action_topic_uuid_1,
        NEW.action_topic_uuid_2
    );

    INSERT INTO
        change_deltas(
            change_id,
            new,
            action_format,
            action_topic_id_1,
            action_topic_id_2
        )
    SELECT
        currval('changes'),
        1,
        NEW.action_format,
        t1.id,
        t2.id
    FROM
        (SELECT 1)
    LEFT JOIN
        topics t1
    ON
        t1.uuid = NEW.action_topic_uuid_1
    LEFT JOIN
        topics t2
    ON
        t2.uuid = NEW.action_topic_uuid_2
    ;

    SELECT RAISE(IGNORE);
END;
