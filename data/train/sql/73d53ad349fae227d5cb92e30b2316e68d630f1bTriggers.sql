-- Triggers

DELIMITER //
CREATE TRIGGER deleteEvenement
AFTER DELETE ON alerteEvenement
FOR EACH ROW
BEGIN
	DELETE FROM ajoutEvenement WHERE type = OLD.type AND nom_ligne = OLD.nom_ligne AND nom_arret = OLD.nom_arret;
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER insertAlerte
AFTER INSERT ON ajoutEvenement
FOR EACH ROW
BEGIN
	IF ((SELECT COUNT(*) FROM alerteEvenement al WHERE al.type = NEW.type AND al.nom_ligne = NEW.nom_ligne AND al.nom_arret = NEW.nom_arret) = 0) OR NEW.description !="" THEN
		INSERT INTO alerteEvenement (nombre, nom_ligne, nom_arret, type, description, date_time) VALUES (1, NEW.nom_ligne, NEW.nom_arret, NEW.type, NEW.description, NEW.date_time);
	ELSE
		IF (SELECT COUNT(*) FROM alerteEvenement al WHERE al.type = NEW.type AND al.nom_ligne = NEW.nom_ligne AND al.nom_arret = NEW.nom_arret AND TIMESTAMPDIFF(HOUR, al.date_time, LOCALTIME) < 2) > 0 THEN
			UPDATE alerteEvenement al SET nombre = nombre + 1, date_time = NEW.date_time WHERE al.type = NEW.type AND al.nom_ligne = NEW.nom_ligne AND al.nom_arret = NEW.nom_arret;
		ELSE
			UPDATE alerteEvenement al SET nombre = 1, date_time = NEW.date_time WHERE al.type = NEW.type AND al.nom_ligne = NEW.nom_ligne AND al.nom_arret = NEW.nom_arret;
		END IF;
	END IF;
END;
//
DELIMITER ;