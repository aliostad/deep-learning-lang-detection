DELIMITER $$

DROP TRIGGER IF EXISTS articlehistorian $$

CREATE TRIGGER articlehistorian 
  BEFORE UPDATE ON jos_content
  FOR EACH ROW
    BEGIN
      IF NEW.version <> OLD.version THEN
        INSERT INTO jos_content_history (revision_date,`id`, `title`, `alias`, `title_alias`, `introtext`, `fulltext`, `state`, `sectionid`, `mask`, `catid`, `created`, `created_by`, `created_by_alias`, `modified`, `modified_by`, `checked_out`, `checked_out_time`, `publish_up`, `publish_down`, `images`, `urls`, `attribs`, `version`, `parentid`, `ordering`, `metakey`, `metadesc`, `access`, `hits`, `metadata`)
          VALUES (now(),OLD.`id`, OLD.`title`, OLD.`alias`, OLD.`title_alias`, OLD.`introtext`, OLD.`fulltext`, OLD.`state`, OLD.`sectionid`, OLD.`mask`, OLD.`catid`, OLD.`created`, OLD.`created_by`, OLD.`created_by_alias`, OLD.`modified`, OLD.`modified_by`, OLD.`checked_out`, OLD.`checked_out_time`, OLD.`publish_up`, OLD.`publish_down`, OLD.`images`, OLD.`urls`, OLD.`attribs`, OLD.`version`, OLD.`parentid`, OLD.`ordering`, OLD.`metakey`, OLD.`metadesc`, OLD.`access`, OLD.`hits`, OLD.`metadata`);
       END IF;
    END $$

DELIMITER ;

