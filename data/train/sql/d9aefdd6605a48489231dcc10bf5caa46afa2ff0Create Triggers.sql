/**  DECLARE nExistencia INT;
  SET nExistencia = (SELECT * FROM ingresos_seriales WHERE idserial = NEW.idserial);**/

  /** IF OLD.idserial!='' THEN
      INSERT INTO salidas_seriales SELECT
  END IF ; **/

/** Opening Database
USE `syrux100vfp`;

DROP TRIGGER IF EXISTS trg_actualizar_existencia_items;

DELIMITER $$
CREATE TRIGGER trg_actualizar_existencia_items BEFORE UPDATE ON items
FOR EACH ROW
BEGIN
    SET NEW.existencia = (NEW.entradas+NEW.devolucion)-(NEW.salidas+NEW.reservado);
END$$
DELIMITER ;**/