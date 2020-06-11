/*Triggers*/
/*Norms and Incrementation of counters*/

DELIMITER //
CREATE TRIGGER create_view_event_trigger AFTER INSERT ON view
FOR EACH ROW
BEGIN

INSERT INTO event(user, content, action, checked) VALUES (NEW.user, NEW.content, 1, 0);
UPDATE content SET num_of_views = num_of_views+1 WHERE content.id = NEW.content;

END//

/* */

CREATE TRIGGER create_upload_event_trigger AFTER INSERT ON user_content
FOR EACH ROW
BEGIN

INSERT INTO event(user, content, action, checked) VALUES (NEW.user, NEW.content, 2, 0);

END//

/* */

CREATE TRIGGER create_complaint_event_trigger AFTER INSERT ON complaint
FOR EACH ROW
BEGIN
INSERT INTO event(user, content, action, complaint_category, checked) VALUES (NEW.user, NEW.content, 3, NEW.complain_category, 0);
UPDATE content SET num_of_complaints = num_of_complaints+1 WHERE content.id = NEW.content;
END//

DELIMITER ;
