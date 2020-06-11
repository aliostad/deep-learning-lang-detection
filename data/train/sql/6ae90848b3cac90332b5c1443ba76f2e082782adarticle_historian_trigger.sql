DELIMITER $$

DROP TRIGGER IF EXISTS articlehistorian $$

CREATE TRIGGER articlehistorian 
  BEFORE UPDATE ON jos_content
  FOR EACH ROW
    BEGIN
      IF NEW.version <> OLD.version THEN
        INSERT INTO jos_content_history 
        (revision_date,`id`,  `asset_id`,  `title`,  `alias`,  `introtext`,  
        `fulltext`,  `state`,  `catid`,  `created`,  `created_by`,  
        `created_by_alias`,  `modified`,  `modified_by`,  `checked_out`, 
        `checked_out_time`,  `publish_up`,  `publish_down`,  `images`,  
        `urls`,  `attribs`,  `version`,  `ordering`,  `metakey`,  `metadesc`,  
        `access`,  `hits`,  `metadata`,  `featured`,  `language`,  `xreference`)
         VALUES 
        (now(),OLD.`id`, OLD.`asset_id`, OLD.`title`, OLD.`alias`, 
        OLD.`introtext`, OLD.`fulltext`, OLD.`state`, OLD.`catid`, 
        OLD.`created`, OLD.`created_by`, OLD.`created_by_alias`, 
        OLD.`modified`, OLD.`modified_by`, OLD.`checked_out`, 
        OLD.`checked_out_time`, OLD.`publish_up`, OLD.`publish_down`, 
        OLD.`images`, OLD.`urls`, OLD.`attribs`, OLD.`version`, 
        OLD.`ordering`, OLD.`metakey`, OLD.`metadesc`, OLD.`access`, 
        OLD.`hits`, OLD.`metadata`, OLD.`featured`, OLD.`language`, 
        OLD.`xreference`);
       END IF;
    END $$

DELIMITER ;

/*
CREATE TABLE `jos_content_history` (
`id`,  `asset_id`,  `title`,  `alias`,  `introtext`,  `fulltext`,  `state`,  `catid`,  `created`,  `created_by`,  `created_by_alias`,  `modified`,  `modified_by`,  `checked_out`,  `checked_out_time`,  `publish_up`,  `publish_down`,  `images`,  `urls`,  `attribs`,  `version`,  `ordering`,  `metakey`,  `metadesc`,  `access`,  `hits`,  `metadata`,  `featured`,  `language`,  `xreference`, 
  PRIMARY KEY (`revision_date`,`id`),
  KEY `idx_access` (`access`),
  KEY `idx_checkout` (`checked_out`),
  KEY `idx_state` (`state`),
  KEY `idx_catid` (`catid`),
  KEY `idx_createdby` (`created_by`),
  KEY `idx_featured_catid` (`featured`,`catid`),
  KEY `idx_language` (`language`),
  KEY `idx_xreference` (`xreference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
