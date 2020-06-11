CREATE DATABASE  IF NOT EXISTS `sheweb2013` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `sheweb2013`;
-- MySQL dump 10.13  Distrib 5.5.28, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: sheweb2013
-- ------------------------------------------------------
-- Server version	5.5.28-0ubuntu0.12.04.3-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `usergroups_access`
--

DROP TABLE IF EXISTS `usergroups_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usergroups_access` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `element` int(3) NOT NULL,
  `element_id` bigint(20) NOT NULL,
  `module` varchar(140) NOT NULL,
  `controller` varchar(140) NOT NULL,
  `permission` varchar(7) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usergroups_access`
--

LOCK TABLES `usergroups_access` WRITE;
/*!40000 ALTER TABLE `usergroups_access` DISABLE KEYS */;
INSERT INTO `usergroups_access` VALUES (2,2,4,'Parametros','pais','read'),(5,2,5,'Parametros','pais','read'),(8,2,5,'Parametros','autor','read'),(9,2,5,'Parametros','autor','write'),(10,2,5,'Parametros','autor','admin'),(11,2,5,'Parametros','pais','write'),(12,2,5,'Parametros','pais','admin'),(13,2,5,'Parametros','bodega','read'),(14,2,5,'Parametros','bodega','write'),(15,2,5,'Parametros','bodega','admin'),(16,2,5,'Parametros','categoria','read'),(17,2,5,'Parametros','categoria','write'),(18,2,5,'Parametros','categoria','admin'),(19,2,5,'Parametros','ciudad','read'),(20,2,5,'Parametros','ciudad','write'),(21,2,5,'Parametros','ciudad','admin'),(22,2,5,'Parametros','condicioncomercial','read'),(23,2,5,'Parametros','condicioncomercial','write'),(24,2,5,'Parametros','condicioncomercial','admin'),(25,2,5,'Parametros','departamento','read'),(26,2,5,'Parametros','departamento','write'),(27,2,5,'Parametros','departamento','admin'),(28,2,5,'Parametros','editorial','read'),(29,2,5,'Parametros','editorial','write'),(30,2,5,'Parametros','editorial','admin'),(31,2,5,'Parametros','item','read'),(32,2,5,'Parametros','item','write'),(33,2,5,'Parametros','item','admin'),(34,2,5,'userGroups','admin','read'),(35,2,5,'userGroups','admin','write'),(36,2,5,'userGroups','admin','admin'),(37,2,5,'userGroups','user','write'),(38,2,5,'userGroups','user','admin'),(39,2,5,'Parametros','moneda','read'),(40,2,5,'Parametros','moneda','write'),(41,2,5,'Parametros','moneda','admin'),(42,2,5,'Parametros','porcentajesreservas','read'),(43,2,5,'Parametros','porcentajesreservas','write'),(44,2,5,'Parametros','porcentajesreservas','admin'),(45,2,5,'Parametros','terceros','read'),(46,2,5,'Parametros','terceros','write'),(47,2,5,'Parametros','terceros','admin'),(48,2,5,'Parametros','tipoformato','read'),(49,2,5,'Parametros','tipoformato','write'),(50,2,5,'Parametros','tipoformato','admin'),(51,2,5,'Parametros','tipopedidosproveedores','read'),(52,2,5,'Parametros','tipopedidosproveedores','write'),(53,2,5,'Parametros','tipopedidosproveedores','admin'),(54,2,5,'Parametros','tiposdocumentosanexos','read'),(55,2,5,'Parametros','tiposdocumentosanexos','write'),(56,2,5,'Parametros','tiposdocumentosanexos','admin'),(57,2,5,'Parametros','tiposidentificacion','read'),(58,2,5,'Parametros','tiposidentificacion','write'),(59,2,5,'Parametros','tiposidentificacion','admin'),(60,2,5,'Parametros','tiposterceros','read'),(61,2,5,'Parametros','tiposterceros','write'),(62,2,5,'Parametros','tiposterceros','admin'),(63,2,5,'Parametros','tipostransporte','read'),(64,2,5,'Parametros','tipostransporte','write'),(65,2,5,'Parametros','tipostransporte','admin'),(69,2,5,'EntradasAlmacen','pedidosproveedoresentradasalmacen','read'),(70,2,5,'EntradasAlmacen','pedidosproveedoresentradasalmacen','write'),(71,2,5,'EntradasAlmacen','pedidosproveedoresentradasalmacen','admin'),(72,2,5,'PedidosProveedores','item','read'),(73,2,5,'PedidosProveedores','item','write'),(74,2,5,'PedidosProveedores','item','admin'),(75,2,5,'PedidosProveedores','terceros','read'),(76,2,5,'PedidosProveedores','terceros','write'),(77,2,5,'PedidosProveedores','terceros','admin'),(78,2,5,'PedidosProveedores','porcentajesreservas','read'),(79,2,5,'PedidosProveedores','porcentajesreservas','write'),(80,2,5,'PedidosProveedores','porcentajesreservas','admin'),(81,2,5,'PedidosProveedores','pedidosproveedores','read'),(82,2,5,'PedidosProveedores','pedidosproveedores','write'),(83,2,5,'PedidosProveedores','pedidosproveedores','admin'),(84,2,5,'PedidosProveedores','pedidosproveedoresdocumentos','read'),(85,2,5,'PedidosProveedores','pedidosproveedoresdocumentos','write'),(86,2,5,'PedidosProveedores','pedidosproveedoresdocumentos','admin'),(87,2,5,'PedidosProveedores','pedidosproveedoresitemdetallereserva','read'),(88,2,5,'PedidosProveedores','pedidosproveedoresitemdetallereserva','write'),(89,2,5,'PedidosProveedores','pedidosproveedoresitemdetallereserva','admin'),(90,2,5,'PedidosProveedores','pedidosproveedoresitems','read'),(91,2,5,'PedidosProveedores','pedidosproveedoresitems','write'),(92,2,5,'PedidosProveedores','pedidosproveedoresitems','admin'),(93,2,5,'PedidosProveedores','proyectosespeciales','read'),(94,2,5,'PedidosProveedores','proyectosespeciales','write'),(95,2,5,'PedidosProveedores','proyectosespeciales','admin'),(96,2,5,'PedidosProveedores','proyectosespecialesHasUsergroupsUser','read'),(97,2,5,'PedidosProveedores','proyectosespecialesHasUsergroupsUser','write'),(98,2,5,'PedidosProveedores','proyectosespecialesHasUsergroupsUser','admin'),(99,2,4,'EntradasAlmacen','pedidosproveedoresentradasalmacen','read'),(100,2,4,'EntradasAlmacen','pedidosproveedoresentradasalmacen','write'),(101,2,4,'EntradasAlmacen','pedidosproveedoresentradasalmacen','admin'),(102,2,4,'Parametros','autor','read'),(103,2,4,'Parametros','bodega','read'),(104,2,4,'Parametros','categoria','read'),(105,2,4,'Parametros','ciudad','read'),(106,2,4,'Parametros','condicioncomercial','read'),(107,2,4,'Parametros','departamento','read'),(108,2,4,'Parametros','editorial','read'),(109,2,4,'Parametros','item','read'),(110,2,4,'Parametros','moneda','read'),(111,2,4,'Parametros','porcentajesreservas','read'),(112,2,4,'Parametros','terceros','read'),(113,2,4,'Parametros','tipoformato','read'),(114,2,4,'Parametros','tipopedidosproveedores','read'),(115,2,4,'Parametros','tiposdocumentosanexos','read'),(116,2,4,'Parametros','tiposidentificacion','read'),(117,2,4,'Parametros','tiposterceros','read'),(118,2,4,'Parametros','tipostransporte','read'),(119,2,4,'PedidosProveedores','item','read'),(120,2,4,'PedidosProveedores','pedidosproveedores','read'),(121,2,4,'PedidosProveedores','pedidosproveedoresdocumentos','read'),(122,2,4,'PedidosProveedores','pedidosproveedoresitemdetallereserva','read'),(123,2,4,'PedidosProveedores','pedidosproveedoresitems','read'),(124,2,4,'PedidosProveedores','porcentajesreservas','read'),(125,2,4,'PedidosProveedores','proyectosespeciales','read'),(126,2,4,'PedidosProveedores','proyectosespecialesHasUsergroupsUser','read'),(127,2,4,'PedidosProveedores','terceros','read'),(128,2,5,'EntradasAlmacen','default','read'),(129,2,5,'Parametros','default','read'),(130,2,5,'PedidosProveedores','default','read'),(131,2,3,'PedidosProveedores','default','read'),(132,2,3,'PedidosProveedores','item','read'),(133,2,3,'PedidosProveedores','pedidosproveedores','read'),(134,2,3,'PedidosProveedores','pedidosproveedoresdocumentos','read'),(135,2,3,'PedidosProveedores','pedidosproveedoresitemdetallereserva','read'),(136,2,3,'PedidosProveedores','pedidosproveedoresitems','read'),(137,2,4,'EntradasAlmacen','default','read'),(138,2,4,'Parametros','default','read'),(139,2,4,'PedidosProveedores','default','read');
/*!40000 ALTER TABLE `usergroups_access` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-01-18 17:22:13
