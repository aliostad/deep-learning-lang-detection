drop trigger tg_bi_registered;

CREATE TRIGGER tg_bi_registered
BEFORE INSERT ON Registered
FOR EACH ROW
	SET NEW.firstname = 
		CASE WHEN 
			CHAR_LENGTH(NEW.firstname) = 0 THEN NULL 
		ELSE NEW.firstname
	END;

	SET NEW.lastname =
		CASE WHEN
			CHAR_LENGTH(NEW.lastname) = 0 THEN NULL
		ELSE NEW.lastname
	END;

    SET NEW.phonenumber = 
		CASE WHEN 
			CHAR_LENGTH(NEW.phonenumber) = 0 THEN NULL 
		ELSE NEW.phonenumber
	END;

	SET NEW.email =
		CASE WHEN
			CHAR_LENGTH(NEW.email) = 0 THEN NULL
		ELSE NEW.email
	END;

	SET NEW.BadgeName =
		CASE WHEN
			CHAR_LENGTH(NEW.BadgeName) = 0 THEN NULL
		ELSE NEW.BadgeName
	END;