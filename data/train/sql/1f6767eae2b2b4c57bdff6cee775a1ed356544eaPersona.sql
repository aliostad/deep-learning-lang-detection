/*TABLA Y TRIGGERS PARA PERSONAS*/
CREATE TABLE IF NOT EXISTS `aud_personas_log` (
  `id` int(11) NOT NULL,
  `apellido` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `nrodocumento` varchar(300) COLLATE utf8_spanish_ci DEFAULT NULL,
  `sexo` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fechanacimiento` timestamp NULL DEFAULT NULL,
  `pais_id` int(11) DEFAULT NULL,
  `provincia_id` int(11) DEFAULT NULL,
  `partido_id` int(11) DEFAULT NULL,
  `localidad_id` int(11) DEFAULT NULL,
  `domicilio` varchar(1000) COLLATE utf8_spanish_ci DEFAULT NULL,
  `usuario` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT NULL,
  `modi` tinyint(1) DEFAULT NULL,
  `baja` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;


    /*update*/
CREATE TRIGGER `tr_personas_modi_log` AFTER UPDATE ON `personas`
FOR EACH ROW insert into aud_personas_log (id,apellido,nombre,nrodocumento,sexo,fechanacimiento,pais_id,provincia_id,partido_id,localidad_id,domicilio,usuario,fecha,modi)
values (OLD.id,OLD.apellido,OLD.nombre,OLD.nrodocumento,OLD.sexo,OLD.fechanacimiento,OLD.pais_id,OLD.provincia_id,OLD.partido_id,OLD.localidad_id,OLD.domicilio,NEW.usuario_modi,NOW(), 1);  

    /*delete*/
CREATE TRIGGER `tr_personas_baja_log` AFTER DELETE ON `personas`
 FOR EACH ROW insert into aud_personas_log (id,apellido,nombre,nrodocumento,sexo,fechanacimiento,pais_id,provincia_id,partido_id,localidad_id,domicilio,usuario,fecha,baja)
values (OLD.id,OLD.apellido,OLD.nombre,OLD.nrodocumento,OLD.sexo,OLD.fechanacimiento,OLD.pais_id,OLD.provincia_id,OLD.partido_id,OLD.localidad_id,OLD.domicilio,OLD.usuario_modi,NOW(), 1); 
