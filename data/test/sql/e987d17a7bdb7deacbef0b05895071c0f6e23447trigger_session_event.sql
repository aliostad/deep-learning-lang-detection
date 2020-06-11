
DROP TRIGGER IF EXISTS session_event_after_insert;

DROP TRIGGER IF EXISTS session_event_update;

DROP TRIGGER IF EXISTS session_event_delete;

DELIMITER //
CREATE TRIGGER session_event_after_insert
    AFTER INSERT ON `session_event`
    FOR EACH ROW

BEGIN
 INSERT INTO `subsmanager`.`session_event_archive`
	(`id`,
	`schedule_item_id`,
	`session_event_date`,
	`session_fee_numbers_sold`,
	`session_fee_revenue_sold`,
	`date_updated`,
	`date_created`,
	`operation`)
	VALUES
	(
		NEW.id,
		NEW.schedule_item_id,
		NEW.session_event_date,
		NEW.session_fee_numbers_sold,
		NEW.session_fee_revenue_sold,
		NEW.date_updated,
		NEW.date_created,
		'INSERT'
    );
END //

CREATE TRIGGER session_event_update
    BEFORE UPDATE ON `session_event`
    FOR EACH ROW
BEGIN
	INSERT INTO `subsmanager`.`session_event_archive`
	(`id`,
	 `schedule_item_id`,
	 `session_event_date`,
	 `session_fee_numbers_sold`,
	 `session_fee_revenue_sold`,
	 `date_updated`,
	 `date_created`,
   `operation`)
	VALUES
		(
			NEW.id,
			NEW.schedule_item_id,
			NEW.session_event_date,
			NEW.session_fee_numbers_sold,
			NEW.session_fee_revenue_sold,
			NEW.date_updated,
			NEW.date_created,
			'UPDATE'
		);
END //

CREATE TRIGGER session_event_delete
    BEFORE DELETE ON `session_event`
    FOR EACH ROW
BEGIN
	INSERT INTO `subsmanager`.`session_event_archive`
	(`id`,
	 `schedule_item_id`,
	 `session_event_date`,
	 `session_fee_numbers_sold`,
	 `session_fee_revenue_sold`,
	 `date_updated`,
	 `date_created`,
	 `operation`)
	VALUES
		(
			OLD.id,
			OLD.schedule_item_id,
			OLD.session_event_date,
			OLD.session_fee_numbers_sold,
			OLD.session_fee_revenue_sold,
			OLD.date_updated,
			OLD.date_created,
			'DELETE'
		);
END //