LOCK TABLES `actions` WRITE;
INSERT INTO `actions` VALUES (1,'unlock'),(2,'lock'),(3,'pop'),(4,'add ibutton'),(5,'remove ibutton');
UNLOCK TABLES;

LOCK TABLES `denials` WRITE;
INSERT INTO `denials` VALUES (1,2,2,NULL,NULL),(2,1,2,NULL,NULL);
UNLOCK TABLES;

LOCK TABLES `doors` WRITE;
INSERT INTO `doors` VALUES (1,'z123',1,'Door 1',NULL),(2,'z124',1,'Door 2',NULL),(3,'e321',2,'Door 3',NULL);
UNLOCK TABLES;

LOCK TABLES `interfaces` WRITE;
INSERT INTO `interfaces` VALUES (1,'zigbee'),(2,'ethernet');
UNLOCK TABLES;
