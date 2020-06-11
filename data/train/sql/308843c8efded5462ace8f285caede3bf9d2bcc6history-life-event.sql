CREATE TABLE `Life_Event_Log` (
  `life_event_id_log` int(11) NOT NULL AUTO_INCREMENT,
  `life_event_id` int(11) NOT NULL ,
  `headline` varchar(254) DEFAULT NULL COMMENT 'headline + text = a tweet :-)',
  `text` text COMMENT 'Can be the extended story behind the life event or simply a longer description of it',
  `richtext` text,
  `type` varchar(45) DEFAULT NULL COMMENT 'OPEN TYPE of the Life event for classification purposes\\n\\nBIRTH\\nMARRIAGE\\nTRAVEL\\nGRADUATION\\nMEMORY\\n...',
  `visibility` int(11) DEFAULT NULL COMMENT '0, private. 1, public',
  `contributor_id` int(11) DEFAULT '1' COMMENT 'There is always a contributor for LifeEvents. Is the Person who contributed this life event to the system. The system contributor is id=0\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n',
  `creation_date` datetime DEFAULT NULL,
  `locale` varchar(10) DEFAULT NULL,
  `location_id` bigint(20) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `fuzzy_startdate` bigint(20) DEFAULT NULL,
  `fuzzy_enddate` bigint(20) DEFAULT NULL,
  `public_memento_id` bigint(20) DEFAULT NULL,
  action ENUM('create','update','delete'),
	ts TIMESTAMP,
  PRIMARY KEY (`life_event_id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=latin1;


DELIMITER #
CREATE TRIGGER ai_life_event AFTER INSERT ON Life_Event FOR EACH ROW
BEGIN
  INSERT INTO Life_Event_Log 
	(	action,ts,life_event_id,
		headline, `text`, richtext, `type`, visibility,
		contributor_id, creation_date, locale, 
		location_id, question_id, fuzzy_startdate,
		fuzzy_enddate, public_memento_id)
  VALUES
	(	'create',NOW(),NEW.life_event_id,
		NEW.headline, NEW.`text`, NEW.richtext, NEW.`type`, NEW.visibility,
		NEW.contributor_id, NEW.creation_date, NEW.locale, 
		NEW.location_id, NEW.question_id, NEW.fuzzy_startdate,
		NEW.fuzzy_enddate, NEW.public_memento_id);
END#

DELIMITER #
CREATE TRIGGER au_life_event AFTER UPDATE ON Life_Event
FOR EACH ROW
BEGIN
  INSERT INTO Life_Event_Log
	(action,ts,life_event_id,
		headline,`text`,richtext,`type`,visibility,contributor_id,
		creation_date, locale,location_id,question_id,fuzzy_startdate,
		fuzzy_enddate, public_memento_id)
  VALUES('update',NOW(),NEW.life_event_id,
		NEW.headline,NEW.`text`,NEW.richtext,NEW.`type`,NEW.visibility,NEW.contributor_id,
		NEW.creation_date, NEW.locale,NEW.location_id,NEW.question_id,NEW.fuzzy_startdate,
		NEW.fuzzy_enddate, NEW.public_memento_id);
END#

DELIMITER #
CREATE TRIGGER ad_life_event AFTER DELETE ON Life_Event
FOR EACH ROW
BEGIN
  INSERT INTO Life_Event_Log 
	(action,ts,life_event_id,
		headline,`text`,richtext,`type`,visibility,contributor_id,
		creation_date, locale,location_id,question_id,fuzzy_startdate,
		fuzzy_enddate, public_memento_id)
  VALUES('delete',NOW(),OLD.life_event_id,
		OLD.headline,OLD.`text`,OLD.richtext,OLD.`type`,OLD.visibility,OLD.contributor_id,
		OLD.creation_date, OLD.locale,OLD.location_id,OLD.question_id,OLD.fuzzy_startdate,
		OLD.fuzzy_enddate, OLD.public_memento_id);
END;