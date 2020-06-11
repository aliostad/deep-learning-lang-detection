
-- estructura de la tabla bitacora

CREATE TABLE IF NOT EXISTS `bitacora` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operacion` varchar(10) DEFAULT NULL,
  `host` varchar(30) NOT NULL,
  `modificado` datetime DEFAULT NULL,
  `tabla` varchar(40) NOT NULL,
  `tupla_antes` varchar(1000) DEFAULT NULL,
  `tupla_despues` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;



DROP TRIGGER IF EXISTS `biusernew`;
CREATE TRIGGER `biusernew` AFTER INSERT ON `usuario`
FOR EACH ROW INSERT INTO bitacora(host, operacion, modificado, tabla, tupla_antes, tupla_despues) 
VALUES (SUBSTRING(USER(), (INSTR(USER(),"@")+1)),"INSERTAR", NOW(), "USUARIO","",CONCAT(NEW.ID,' ', NEW.nombre,' ',NEW.apellido_paterno,' ',NEW.apellido_materno,' ',NEW.telefono, ' ', NEW.email,' ',NEW.fecha_nacimiento,' ',NEW.login));


DROP TRIGGER IF EXISTS `biuserdelete`;
CREATE TRIGGER `biuserdelete` AFTER DELETE ON `usuario`
FOR EACH ROW INSERT INTO bitacora(host, operacion, modificado, tabla, tupla_antes, tupla_despues) 
VALUES (SUBSTRING(USER(), (INSTR(USER(),"@")+1)),"ELIMINAR", NOW(), "USUARIO",CONCAT(OlD.ID,' ', OlD.nombre,' ',OlD.apellido_paterno,' ',OlD.apellido_materno,' ',OlD.telefono, ' ', OlD.email,' ',OlD.fecha_nacimiento,' ',OlD.login),' ');

DROP TRIGGER IF EXISTS `biuserupdate`;
CREATE TRIGGER `biuserupdate` AFTER UPDATE ON `usuario`
FOR EACH ROW INSERT INTO bitacora(host, operacion, modificado, tabla, tupla_antes, tupla_despues) 
VALUES (SUBSTRING(USER(), (INSTR(USER(),"@")+1)),"MODIFICAR", NOW(), "USUARIO",CONCAT(OlD.ID,' ', OlD.nombre,' ',OlD.apellido_paterno,' ',OlD.apellido_materno,' ',OlD.telefono, ' ', OlD.email,' ',OlD.fecha_nacimiento,' ',OlD.login),CONCAT(NEW.ID,' ', NEW.nombre,' ',NEW.apellido_paterno,' ',NEW.apellido_materno,' ',NEW.telefono, ' ', NEW.email,' ',NEW.fecha_nacimiento,' ',NEW.login));

DROP TRIGGER IF EXISTS `biproyecinsert`;
CREATE TRIGGER `biproyecinsert` AFTER INSERT ON `proyecto`
FOR EACH ROW INSERT INTO bitacora(host, operacion, modificado, tabla, tupla_antes, tupla_despues) 
VALUES (SUBSTRING(USER(), (INSTR(USER(),"@")+1)),"INSERTAR", NOW(), "PROYECTO","",CONCAT(NEW.ID,' ', NEW.nombre,' ',NEW.objetivo_general,' ',NEW.descripcion,' ',NEW.fecha_registro,' ',NEW.tipo_proyecto,' ',NEW.estado_proyecto));


DROP TRIGGER IF EXISTS `biproydelet`;
CREATE TRIGGER `biproydelet` AFTER DELETE ON `proyecto`
FOR EACH ROW INSERT INTO bitacora(host, operacion, modificado, tabla, tupla_antes, tupla_despues) 
VALUES (SUBSTRING(USER(), (INSTR(USER(),"@")+1)),"ELIMINAR", NOW(), "PROYECTO",CONCAT(OlD.ID,' ',OlD.nombre,' ',OlD.objetivo_general,' ',OlD.descripcion,' ',OlD.fecha_registro,' ',OlD.tipo_proyecto,' ',OlD.estado_proyecto),' ');

DROP TRIGGER IF EXISTS `biproyeupdate`;
CREATE TRIGGER `biproyeupdate` AFTER UPDATE ON `proyecto`
FOR EACH ROW INSERT INTO bitacora(host, operacion, modificado, tabla, tupla_antes, tupla_despues) 
VALUES (SUBSTRING(USER(), (INSTR(USER(),"@")+1)),"MODIFICAR", NOW(), "PROYECTO",CONCAT(OlD.ID,' ',OlD.nombre,' ',OlD.objetivo_general,' ',OlD.descripcion,' ',OlD.fecha_registro,' ',OlD.tipo_proyecto,' ',OlD.estado_proyecto),CONCAT(NEW.ID,' ', NEW.nombre,' ',NEW.objetivo_general,' ',NEW.descripcion,' ',NEW.fecha_registro,' ',NEW.tipo_proyecto,' ',NEW.estado_proyecto));
