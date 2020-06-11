# --- !Ups

DROP TRIGGER users_au_trg;

CREATE TRIGGER users_au_trg
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
	UPDATE surveys SET email = NEW.email
		WHERE user_id = NEW.id;;
	UPDATE contacts SET user = NEW.email
		WHERE user_id = NEW.id;;
	UPDATE contact_lists SET user = NEW.email
		WHERE user_id = NEW.id;;
	UPDATE contact_list_contacts SET user = NEW.email
		WHERE user_id = NEW.id;;	
END;


# --- !Downs

DROP TRIGGER users_au_trg;

CREATE TRIGGER users_au_trg
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
	UPDATE surveys SET email = NEW.email
		WHERE user_type_id = NEW.id;;
	UPDATE contacts SET user = NEW.email
		WHERE user_id = NEW.id;;
	UPDATE contact_lists SET user = NEW.email
		WHERE user_id = NEW.id;;
	UPDATE contact_list_contacts SET user = NEW.email
		WHERE user_id = NEW.id;;	
END;
