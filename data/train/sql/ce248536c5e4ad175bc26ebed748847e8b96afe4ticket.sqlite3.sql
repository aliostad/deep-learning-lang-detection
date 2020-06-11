DROP TRIGGER IF EXISTS tickets_tickettierchange_trigger;
DROP TRIGGER IF EXISTS tickets_ticketstatuschange_trigger;

CREATE TRIGGER tickets_tickettierchange_trigger AFTER UPDATE OF tier_id
ON tickets_ticket
WHEN new.tier_id <> old.tier_id
BEGIN
    INSERT INTO tickets_tickettierchange
    (
        ticket_id,
        date_time,
        new_tier_id,
        old_tier_id,
        profile_id
    )
    VALUES
    (
        new.id,
        datetime('now'),
        new.tier_id,
        old.tier_id,
        new.profile_changed_id
    );
END;

CREATE TRIGGER tickets_ticketstatuschange_trigger AFTER UPDATE OF status_id
ON tickets_ticket
WHEN new.status_id <> old.status_id
BEGIN
    INSERT INTO tickets_ticketstatuschange
    (
        ticket_id,
        date_time,
        new_status_id,
        old_status_id,
        profile_id
    )
    VALUES
    (
        new.id,
        datetime('now'),
        new.status_id,
        old.status_id,
        new.profile_changed_id
    );
END;
