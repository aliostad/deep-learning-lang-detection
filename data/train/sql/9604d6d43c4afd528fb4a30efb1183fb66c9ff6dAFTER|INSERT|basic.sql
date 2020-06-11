BEGIN
IF (NEW.label = 'Switch' AND NEW.valueINT IS NOT NULL) THEN
INSERT INTO switches (node,status,timestamp) VALUES (NEW.node,NEW.valueINT,NOW())
ON DUPLICATE KEY UPDATE status = NEW.valueINT, switches.timestamp = NOW();
END IF;

IF (NEW.commandclass = 67 AND NEW.`index` = 1 AND NEW.valueINT IS NOT NULL) THEN
INSERT INTO thermostat (node,temp,timestamp) VALUES (NEW.node,NEW.valueINT,NOW())
ON DUPLICATE KEY UPDATE thermostat.temp = NEW.valueINT, thermostat.timestamp = NOW();
END IF;

IF (NEW.commandclass = 156 AND NEW.valueINT IS NOT NULL AND NEW.label = 'Flood') THEN
INSERT INTO flood (parentId,homeid,node,instance,valueINT,timestamp) VALUES (NULL,NEW.homeid,NEW.node,NEW.instance,NEW.valueINT,NOW());
END IF;

IF (NEW.commandclass = 49 AND NEW.genre = 1 AND NEW.`index` = 1 AND NEW.valueINT IS NOT NULL) THEN
INSERT INTO temperature (node,temp,timestamp) VALUES (NEW.node,NEW.valueINT,NOW())
ON DUPLICATE KEY UPDATE temperature.temp = NEW.valueINT, temperature.timestamp = NOW();
END IF;

IF (NEW.commandclass = 50 AND NEW.`index` = 8 AND NEW.valueINT IS NOT NULL) THEN
INSERT INTO `power` (`node`,`power`,`timestamp`) VALUES (NEW.node,NEW.valueINT,NOW())
ON DUPLICATE KEY UPDATE `power`.`power` = NEW.valueINT, `power`.`timestamp` = NOW();
END IF;

IF (NEW.commandclass = 50 AND NEW.`index` = 0 AND NEW.valueINT IS NOT NULL) THEN
INSERT INTO `powerUsage` (`nodeId`,`value`,`mtimestamp`) VALUES (NEW.node,NEW.valueINT,NOW())
ON DUPLICATE KEY UPDATE `powerUsage`.`value` = NEW.valueINT, `powerUsage`.`mtimestamp` = NOW();
END IF;


END
