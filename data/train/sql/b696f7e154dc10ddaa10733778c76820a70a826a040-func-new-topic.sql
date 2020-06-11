CREATE TABLE func_new_topic(
    change_id INTEGER,
    id INTEGER NOT NULL DEFAULT (nextval('topics')),
    kind VARCHAR
);


CREATE TRIGGER
    func_new_topic_bi_1
BEFORE INSERT ON
    func_new_topic
FOR EACH ROW
BEGIN

    SELECT debug(
        NEW.change_id,
        NEW.id,
        NEW.kind
    );

    -- TODO if we ever create topic_deltas then move this into there
    UPDATE
        changes
    SET
        ucount = ucount + 1
    WHERE
        id = NEW.change_id
    ;

    -- TODO if we ever create topic_deltas then move this into there
    UPDATE
        changes_pending
    SET
        terms = terms
            || '-' || x'0A'
            || '  _: topic' || x'0A'
            || '  kind: ' || NEW.kind || x'0A'
    WHERE
        change_id = NEW.change_id
    ;

    INSERT INTO
        topics(
            id,
            first_change_id,
            last_change_id,
            kind,
            ctime,
            ctimetz,
            mtime,
            mtimetz,
            lang,
            uuid
        )
    SELECT
        NEW.id,
        NEW.change_id,
        NEW.change_id,
        NEW.kind,
        c.mtime,
        c.mtimetz,
        c.mtime,
        c.mtimetz,
        c.lang,
        sha1_hex(up.terms)
    FROM
        changes c
    INNER JOIN
        changes_pending up
    ON
        up.change_id = c.id
    WHERE
        c.id = NEW.change_id
    ;

    SELECT RAISE(IGNORE);
END;
