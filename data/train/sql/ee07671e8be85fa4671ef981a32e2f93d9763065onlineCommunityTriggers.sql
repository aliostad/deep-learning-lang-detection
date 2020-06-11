/*Triggers*/
/*Norms and Incrementation of counters*/
DELIMITER $$
CREATE TRIGGER create_upload_event_trigger
	AFTER INSERT ON content
	FOR EACH ROW
	BEGIN
		/*Creation fo the event upload */
		INSERT INTO event(user, content, action, checked) VALUES (NEW.owner, NEW.id, 1, 0);
	END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER create_view_event_trigger
	AFTER INSERT ON view
	FOR EACH ROW
	BEGIN
		/*Creation fo the event view */
		INSERT INTO event(user, content, action, checked) VALUES (NEW.user, NEW.content, 2, 0);
		/* Increment of the counter of the content views*/
		UPDATE content SET num_of_views = num_of_views+1 WHERE content.id = NEW.content;
	END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER create_complaint_event_trigger
	AFTER INSERT ON complaint
	FOR EACH ROW
	BEGIN
		/*Creation fo the event complaint */
		INSERT INTO event(user, content, action, complaint_category, checked) VALUES (NEW.user, NEW.content, 3, NEW.complain_category, 0);
		/*Increment of the counter of the contennt complaints*/
		UPDATE content SET num_of_complaints = num_of_complaints+1 WHERE content.id = NEW.content;
	END$$
DELIMITER ;
