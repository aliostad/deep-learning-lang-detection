/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FLASH` (
  `flash_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID of external flash unit',
  `manufacturer_id` int(11) DEFAULT NULL COMMENT 'Manufacturer ID of the flash\n',
  `model` varchar(45) DEFAULT NULL COMMENT 'Model name/number of the flash\n',
  `guide_number` int(11) DEFAULT NULL COMMENT 'Guide number of the flash',
  `gn_info` varchar(45) DEFAULT NULL COMMENT 'Extra freeform info about how the guide number was measured',
  `battery_powered` tinyint(1) DEFAULT NULL COMMENT 'Whether this flash takes batteries',
  `pc_sync` tinyint(1) DEFAULT NULL COMMENT 'Whether the flash has a PC sync socket',
  `hot_shoe` tinyint(1) DEFAULT NULL COMMENT 'Whether the flash has a hot shoe connection',
  `light_stand` tinyint(1) DEFAULT NULL COMMENT 'Whether the flash can be used on a light stand',
  `battery_type` varchar(45) DEFAULT NULL COMMENT 'Type of battery needed in this flash',
  `battery_qty` varchar(45) DEFAULT NULL COMMENT 'Quantity of batteries needed in this flash',
  `manual_control` tinyint(1) DEFAULT NULL COMMENT 'Whether this flash offers manual power control',
  `swivel_head` tinyint(1) DEFAULT NULL COMMENT 'Whether this flash has a horizontal swivel head',
  `tilt_head` tinyint(1) DEFAULT NULL COMMENT 'Whether this flash has a vertical tilt head',
  `zoom` tinyint(1) DEFAULT NULL COMMENT 'Whether this flash can zoom',
  `dslr_safe` tinyint(1) DEFAULT NULL COMMENT 'Whether this flash is safe to use with a digital camera',
  `ttl` tinyint(1) DEFAULT NULL COMMENT 'Whether this flash supports TTL metering',
  `ttl_compatibility` varchar(45) DEFAULT NULL COMMENT 'Compatibility of this flash''s TTL system',
  `trigger_voltage` decimal(4,1) DEFAULT NULL COMMENT 'Trigger voltage of the flash, in Volts',
  `own` tinyint(1) DEFAULT NULL COMMENT 'Whether we currently own this flash',
  PRIMARY KEY (`flash_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
