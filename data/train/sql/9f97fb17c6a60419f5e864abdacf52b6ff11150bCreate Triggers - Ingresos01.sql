USE `syrux100vfp`;

/** Trigger para actualizar el saldo mensual al que pertenece el movimiento**/
DROP TRIGGER IF EXISTS `syrux100vfp`.`trg_antes_insertar_ingresos01` ;
DELIMITER $$

CREATE TRIGGER `syrux100vfp`.`trg_antes_insertar_ingresos01` BEFORE INSERT ON ingresos01
FOR EACH ROW
BEGIN
    UPDATE productos_saldos_mensuales SET entradas=entradas+NEW.cantidad
        WHERE idproducto = NEW.idproducto AND mes=MONTH(NEW.fecha) AND ano=YEAR(NEW.fecha);

        CALL UpdateSaldoProductosSaldosMensuales(NEW.idproducto, MONTH(NEW.fecha),YEAR(NEW.fecha));
END$$

DELIMITER ;