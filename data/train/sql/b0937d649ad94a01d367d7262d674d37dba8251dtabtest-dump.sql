-- MySQL dump 10.10
--
-- Host: localhost    Database: CMAP
-- ------------------------------------------------------
-- Server version	5.0.21
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table cmap_attribute
--


--
-- Dumping data for table cmap_correspondence_evidence
--

INSERT INTO cmap_correspondence_evidence VALUES (1,'1',1,'ANB',NULL,1);
INSERT INTO cmap_correspondence_evidence VALUES (2,'2',2,'ANB',NULL,1);
INSERT INTO cmap_correspondence_evidence VALUES (3,'3',3,'ANB',NULL,1);
INSERT INTO cmap_correspondence_evidence VALUES (4,'4',4,'ANB',NULL,1);
INSERT INTO cmap_correspondence_evidence VALUES (5,'5',5,'ANB',NULL,1);

--
-- Dumping data for table cmap_correspondence_lookup
--

INSERT INTO cmap_correspondence_lookup VALUES (21,6,1,2200.00,1000.00,2700.00,2000.00,3,1,'read','read');
INSERT INTO cmap_correspondence_lookup VALUES (6,21,1,1000.00,2200.00,2000.00,2700.00,1,3,'read','read');
INSERT INTO cmap_correspondence_lookup VALUES (18,5,2,450.00,450.00,1000.00,1000.00,3,1,'read','read');
INSERT INTO cmap_correspondence_lookup VALUES (5,18,2,450.00,450.00,1000.00,1000.00,1,3,'read','read');
INSERT INTO cmap_correspondence_lookup VALUES (23,10,3,3100.00,3100.00,4000.00,4000.00,3,1,'read','read');
INSERT INTO cmap_correspondence_lookup VALUES (10,23,3,3100.00,3100.00,4000.00,4000.00,1,3,'read','read');
INSERT INTO cmap_correspondence_lookup VALUES (26,8,4,500.00,2200.00,1000.00,2700.00,4,1,'read','read');
INSERT INTO cmap_correspondence_lookup VALUES (8,26,4,2200.00,500.00,2700.00,1000.00,1,4,'read','read');
INSERT INTO cmap_correspondence_lookup VALUES (25,7,5,0.00,2000.00,500.00,2300.00,4,1,'read','read');
INSERT INTO cmap_correspondence_lookup VALUES (7,25,5,2000.00,0.00,2300.00,500.00,1,4,'read','read');

--
-- Dumping data for table cmap_correspondence_matrix
--

INSERT INTO cmap_correspondence_matrix VALUES ('1','T1','TI2006','TS','3','T3','TI2006_2','TS',3);
INSERT INTO cmap_correspondence_matrix VALUES ('1','T1','TI2006','TS','4','T4','TI2006_2','TS',2);
INSERT INTO cmap_correspondence_matrix VALUES ('3','T3','TI2006_2','TS','1','T1','TI2006','TS',3);
INSERT INTO cmap_correspondence_matrix VALUES ('4','T4','TI2006_2','TS','1','T1','TI2006','TS',2);

--
-- Dumping data for table cmap_feature
--

INSERT INTO cmap_feature VALUES (1,'1',1,'contig','T1.1',0,0.00,1000.00,1,1);
INSERT INTO cmap_feature VALUES (2,'2',1,'contig','T1.2',0,1000.00,2000.00,1,1);
INSERT INTO cmap_feature VALUES (3,'3',1,'contig','T1.3',0,2000.00,4000.00,1,1);
INSERT INTO cmap_feature VALUES (4,'4',1,'read','R1.g1',0,0.00,500.00,1,1);
INSERT INTO cmap_feature VALUES (5,'5',1,'read','R2.g1',0,450.00,1000.00,1,1);
INSERT INTO cmap_feature VALUES (6,'6',1,'read','R3.g1',0,1000.00,2000.00,1,1);
INSERT INTO cmap_feature VALUES (7,'7',1,'read','R4.g1',0,2000.00,2300.00,1,1);
INSERT INTO cmap_feature VALUES (8,'8',1,'read','R5.b1',0,2200.00,2700.00,1,1);
INSERT INTO cmap_feature VALUES (9,'9',1,'read','R6.b1',0,2650.00,3300.00,1,1);
INSERT INTO cmap_feature VALUES (10,'10',1,'read','R7.g1',0,3100.00,4000.00,1,1);
INSERT INTO cmap_feature VALUES (11,'11',2,'contig','T2.1',0,0.00,1000.00,1,1);
INSERT INTO cmap_feature VALUES (12,'12',2,'read','R10.g1',0,0.00,500.00,1,1);
INSERT INTO cmap_feature VALUES (13,'13',2,'read','R11.g1',0,500.00,1000.00,1,1);
INSERT INTO cmap_feature VALUES (14,'14',3,'contig','T3.1',0,0.00,1000.00,1,1);
INSERT INTO cmap_feature VALUES (15,'15',3,'contig','T3.2',0,1000.00,2000.00,1,1);
INSERT INTO cmap_feature VALUES (16,'16',3,'contig','T3.3',0,2000.00,4000.00,1,1);
INSERT INTO cmap_feature VALUES (17,'17',3,'read','RA.g1',0,0.00,500.00,1,1);
INSERT INTO cmap_feature VALUES (18,'18',3,'read','R2.b1',0,450.00,1000.00,1,1);
INSERT INTO cmap_feature VALUES (19,'19',3,'read','RB.b1',0,1000.00,2000.00,1,1);
INSERT INTO cmap_feature VALUES (20,'20',3,'read','RC.b1',0,2000.00,2300.00,1,1);
INSERT INTO cmap_feature VALUES (21,'21',3,'read','R3.b1',0,2200.00,2700.00,1,1);
INSERT INTO cmap_feature VALUES (22,'22',3,'read','RD.g1',0,2650.00,3300.00,1,1);
INSERT INTO cmap_feature VALUES (23,'23',3,'read','R7.b1',0,3100.00,4000.00,1,1);
INSERT INTO cmap_feature VALUES (24,'24',4,'contig','T4.1',0,0.00,1000.00,1,1);
INSERT INTO cmap_feature VALUES (25,'25',4,'read','R4.b1',0,0.00,500.00,1,1);
INSERT INTO cmap_feature VALUES (26,'26',4,'read','R5.g1',0,500.00,1000.00,1,1);

--
-- Dumping data for table cmap_feature_alias
--

INSERT INTO cmap_feature_alias VALUES (1,1,'T1.A');
INSERT INTO cmap_feature_alias VALUES (2,1,'T1.AA');
INSERT INTO cmap_feature_alias VALUES (3,2,'T1.B');
INSERT INTO cmap_feature_alias VALUES (4,3,'T1.C');
INSERT INTO cmap_feature_alias VALUES (5,11,'T2.A');

--
-- Dumping data for table cmap_feature_correspondence
--

INSERT INTO cmap_feature_correspondence VALUES (1,'1',21,6,1);
INSERT INTO cmap_feature_correspondence VALUES (2,'2',18,5,1);
INSERT INTO cmap_feature_correspondence VALUES (3,'3',23,10,1);
INSERT INTO cmap_feature_correspondence VALUES (4,'4',26,8,1);
INSERT INTO cmap_feature_correspondence VALUES (5,'5',25,7,1);

--
-- Dumping data for table cmap_map
--

INSERT INTO cmap_map VALUES (1,'1',1,'T1',1,0.00,4000.00);
INSERT INTO cmap_map VALUES (2,'2',1,'T2',1,0.00,1000.00);
INSERT INTO cmap_map VALUES (3,'3',2,'T3',1,0.00,4000.00);
INSERT INTO cmap_map VALUES (4,'4',2,'T4',1,0.00,1000.00);

--
-- Dumping data for table cmap_map_set
--

INSERT INTO cmap_map_set VALUES (1,'TI2006','Test Import 2006','Test Import 2006','Seq',1,'2006-05-25',1,1,NULL,NULL,NULL,'bp',0);
INSERT INTO cmap_map_set VALUES (2,'TI2006_2','Test Import 2006.2','Test Import 2006.2','Seq',1,'2006-05-25',1,1,NULL,NULL,NULL,'bp',0);

--
-- Dumping data for table cmap_next_number
--

INSERT INTO cmap_next_number VALUES ('cmap_species',2);
INSERT INTO cmap_next_number VALUES ('cmap_map_set',3);
INSERT INTO cmap_next_number VALUES ('cmap_map',5);
INSERT INTO cmap_next_number VALUES ('cmap_feature',27);
INSERT INTO cmap_next_number VALUES ('cmap_feature_alias',6);
INSERT INTO cmap_next_number VALUES ('cmap_feature_correspondence',6);
INSERT INTO cmap_next_number VALUES ('cmap_correspondence_evidence',6);

--
-- Dumping data for table cmap_saved_link
--


--
-- Dumping data for table cmap_species
--

INSERT INTO cmap_species VALUES (1,'TS','T. species','Test species',1);

--
-- Dumping data for table cmap_xref
--

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

