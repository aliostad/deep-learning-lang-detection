# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: localhost (MySQL 5.6.14)
# Database: congreso
# Generation Time: 2014-04-22 13:53:38 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table asistencias
# ------------------------------------------------------------

LOCK TABLES `asistencias` WRITE;
/*!40000 ALTER TABLE `asistencias` DISABLE KEYS */;

INSERT INTO `asistencias` (`ciudadano_id`, `sesion_id`)
VALUES
	(1,1),
	(2,1);

/*!40000 ALTER TABLE `asistencias` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table bienes_economicos
# ------------------------------------------------------------

LOCK TABLES `bienes_economicos` WRITE;
/*!40000 ALTER TABLE `bienes_economicos` DISABLE KEYS */;

INSERT INTO `bienes_economicos` (`id`, `valor`, `año`, `ciudadano_id`, `detalles`)
VALUES
  (1,10,2010,1,'Auto'),
  (2,20,2010,2,'Auto'),
  (3,10,2011,1,'Auto'),
  (4,20,2011,2,'Auto'),
  (5,10,2012,1,'Auto'),
  (6,20,2012,2,'Auto'),
  (7,10,2013,1,'Auto'),
  (8,20,2013,2,'Auto'),
  (9,20,2014,1,'Auto'),
  (10,10,2014,1,'Bici'),
  (11,15,2014,2,'Auto'),
  (12,15,2014,2,'Moto'),
  (13,50,2010,1,'Barco');


/*!40000 ALTER TABLE `bienes_economicos` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table bloques_politicos
# ------------------------------------------------------------



# Dump of table bloques_politicos_ciudadanos_integrantes
# ------------------------------------------------------------



# Dump of table bloques_politicos_ciudadanos_presidentes
# ------------------------------------------------------------



# Dump of table camaras
# ------------------------------------------------------------

LOCK TABLES `camaras` WRITE;
/*!40000 ALTER TABLE `camaras` DISABLE KEYS */;

INSERT INTO `camaras` (`id`, `tipo`, `año`, `presidente_id`)
VALUES
	(1,'diputados',2010,1),
	(2,'senadores',2010,5),
	(3,'diputados',2011,1),
	(4,'senadores',2011,5),
	(5,'diputados',2012,1),
	(6,'senadores',2012,5),
	(7,'diputados',2013,1),
	(8,'senadores',2013,5),
	(9,'diputados',2014,1),
	(10,'senadores',2014,5);

/*!40000 ALTER TABLE `camaras` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table camaras_diputados
# ------------------------------------------------------------

LOCK TABLES `camaras_diputados` WRITE;
/*!40000 ALTER TABLE `camaras_diputados` DISABLE KEYS */;

INSERT INTO `camaras_diputados` (`id`)
VALUES
	(1),
	(3),
	(5),
	(7),
	(9);

/*!40000 ALTER TABLE `camaras_diputados` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table camaras_senadores
# ------------------------------------------------------------

LOCK TABLES `camaras_senadores` WRITE;
/*!40000 ALTER TABLE `camaras_senadores` DISABLE KEYS */;

INSERT INTO `camaras_senadores` (`id`)
VALUES
	(2),
	(4),
	(6),
	(8),
	(10);

/*!40000 ALTER TABLE `camaras_senadores` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ciudadanos
# ------------------------------------------------------------

LOCK TABLES `ciudadanos` WRITE;
/*!40000 ALTER TABLE `ciudadanos` DISABLE KEYS */;

INSERT INTO `ciudadanos` (`id`, `dni`, `fecha_nacimiento`, `nombre`, `apellido`)
VALUES
	(1,'33252352','1970-04-21','Alejandro','Mataloni'),
	(2,'33234567','1970-04-21','Emiliano','Mancuso'),
	(3,'33212345','1970-04-21','Marisol','Reartes'),
	(4,'33434565','1970-04-21','Maria Lara','Gauder'),
	(5,'25678323','1950-06-05','Aldo','Haydar');

/*!40000 ALTER TABLE `ciudadanos` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table comisiones
# ------------------------------------------------------------

LOCK TABLES `comisiones` WRITE;
/*!40000 ALTER TABLE `comisiones` DISABLE KEYS */;

INSERT INTO `comisiones` (`id`, `camara_diputados_id`, `nombre`, `presidente_id`)
VALUES
	(1,1,'Comision 1',2);

/*!40000 ALTER TABLE `comisiones` ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table diputados
# ------------------------------------------------------------

LOCK TABLES `diputados` WRITE;
/*!40000 ALTER TABLE `diputados` DISABLE KEYS */;

INSERT INTO `diputados` (`id`)
VALUES
	(1),
	(2);

/*!40000 ALTER TABLE `diputados` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table empleados
# ------------------------------------------------------------



# Dump of table integrantes_comisiones
# ------------------------------------------------------------

LOCK TABLES `integrantes_comisiones` WRITE;
/*!40000 ALTER TABLE `integrantes_comisiones` DISABLE KEYS */;

INSERT INTO `integrantes_comisiones` (`diputado_id`, `comision_id`)
VALUES
	(1,1);

/*!40000 ALTER TABLE `integrantes_comisiones` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table leyes
# ------------------------------------------------------------

LOCK TABLES `leyes` WRITE;
/*!40000 ALTER TABLE `leyes` DISABLE KEYS */;

INSERT INTO `leyes` (`id`, `sesion_id`, `proyecto_de_ley_id`)
VALUES
	(1,2,1);

/*!40000 ALTER TABLE `leyes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table partidos_politicos
# ------------------------------------------------------------



# Dump of table partidos_politicos_ciudadanos
# ------------------------------------------------------------



# Dump of table provincias
# ------------------------------------------------------------

LOCK TABLES `provincias` WRITE;
/*!40000 ALTER TABLE `provincias` DISABLE KEYS */;

INSERT INTO `provincias` (`id`, `nombre`, `poblacion`)
VALUES
	(1,'La Pampa',105000);

/*!40000 ALTER TABLE `provincias` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table proyectos_de_ley
# ------------------------------------------------------------

LOCK TABLES `proyectos_de_ley` WRITE;
/*!40000 ALTER TABLE `proyectos_de_ley` DISABLE KEYS */;

INSERT INTO `proyectos_de_ley` (`id`, `fecha_inicio`, `camara_id`, `titulo`, `control_id`, `aprobado_diputados`, `aprobado_senadores`)
VALUES
	(1,'2010-04-21',1,'Proyecto 1',NULL,1,1);

/*!40000 ALTER TABLE `proyectos_de_ley` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table proyectos_de_ley_comisiones
# ------------------------------------------------------------

LOCK TABLES `proyectos_de_ley_comisiones` WRITE;
/*!40000 ALTER TABLE `proyectos_de_ley_comisiones` DISABLE KEYS */;

INSERT INTO `proyectos_de_ley_comisiones` (`proyecto_de_ley_id`, `comision_id`, `informante_id`)
VALUES
	(1,1,1);

/*!40000 ALTER TABLE `proyectos_de_ley_comisiones` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table representaciones
# ------------------------------------------------------------

LOCK TABLES `representaciones` WRITE;
/*!40000 ALTER TABLE `representaciones` DISABLE KEYS */;

INSERT INTO `representaciones` (`ciudadano_id`, `camara_id`, `provincia_id`)
VALUES
	(1,1,1),
	(2,1,1),
	(3,2,1),
	(4,2,1),
	(1,3,1),
	(2,3,1),
	(3,4,1),
	(4,4,1),
	(1,5,1),
	(2,5,1),
	(3,6,1),
	(4,6,1),
	(1,7,1),
	(2,7,1),
	(3,8,1),
	(4,8,1),
	(1,9,1),
	(2,9,1),
	(3,10,1),
	(4,10,1);

/*!40000 ALTER TABLE `representaciones` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sesiones
# ------------------------------------------------------------

LOCK TABLES `sesiones` WRITE;
/*!40000 ALTER TABLE `sesiones` DISABLE KEYS */;

INSERT INTO `sesiones` (`id`, `fecha_inicio`, `fecha_fin`, `camara_id`, `tipo`)
VALUES
	(1,'2010-04-21','2010-04-21',1,'ordinaria'),
	(2,'2013-04-22','2013-04-22',2,'ordinaria');

/*!40000 ALTER TABLE `sesiones` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tipos_de_camara
# ------------------------------------------------------------

LOCK TABLES `tipos_de_camara` WRITE;
/*!40000 ALTER TABLE `tipos_de_camara` DISABLE KEYS */;

INSERT INTO `tipos_de_camara` (`tipo`)
VALUES
	('diputados'),
	('senadores');

/*!40000 ALTER TABLE `tipos_de_camara` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tipos_de_sesion
# ------------------------------------------------------------

LOCK TABLES `tipos_de_sesion` WRITE;
/*!40000 ALTER TABLE `tipos_de_sesion` DISABLE KEYS */;

INSERT INTO `tipos_de_sesion` (`tipo`)
VALUES
	('extraordinaria'),
	('ordinaria'),
	('preparatoria');

/*!40000 ALTER TABLE `tipos_de_sesion` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tipos_de_voto
# ------------------------------------------------------------

LOCK TABLES `tipos_de_voto` WRITE;
/*!40000 ALTER TABLE `tipos_de_voto` DISABLE KEYS */;

INSERT INTO `tipos_de_voto` (`tipo`)
VALUES
	('abstencion'),
	('afirmativo'),
	('ausente'),
	('deshabilitado'),
	('negativo');

/*!40000 ALTER TABLE `tipos_de_voto` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table votos
# ------------------------------------------------------------

LOCK TABLES `votos` WRITE;
/*!40000 ALTER TABLE `votos` DISABLE KEYS */;

INSERT INTO `votos` (`ciudadano_id`, `sesion_id`, `proyecto_de_ley_id`, `tipo_de_voto`)
VALUES
	(1,1,1,'afirmativo'),
	(2,1,1,'afirmativo'),
	(3,2,1,'afirmativo'),
	(4,2,1,'afirmativo');

/*!40000 ALTER TABLE `votos` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
