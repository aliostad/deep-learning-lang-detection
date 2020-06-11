DROP TRIGGER IF EXISTS T_edit_insert;
DROP TRIGGER IF EXISTS T_edit_update;

DELIMITER //
CREATE TRIGGER T_edit_insert AFTER INSERT
ON edits
FOR EACH ROW 
BEGIN
	
	CALL F_Update_Tag_Scores((SELECT edit_origin_id FROM edits));
END;//
DELIMITER ;

CREATE TRIGGER T_edit_update BEFORE UPDATE
ON edits
FOR EACH ROW
SET NEW.edit_dist=(case when (NEW.edit_origin_id <> 0 AND NEW.edit_origin_id <> NEW.id) then levenshtein(NEW.description,(SELECT description FROM edits WHERE( id=NEW.edit_origin_id OR edit_origin_id=NEW.edit_origin_id) ORDER BY id DESC LIMIT 1)) else 0 END);

SET NEW.edit_dist=(case when (NEW.edit_origin_id <> 0 AND NEW.edit_origin_id <> NEW.id) then levenshtein(NEW.description,(SELECT description FROM edits WHERE( id=NEW.edit_origin_id OR edit_origin_id=NEW.edit_origin_id) ORDER BY id DESC LIMIT 1)) else 0 END);
	SET NEW.descr_real_percent_contrib = ROUND(100*(LENGTH((SELECT description FROM edits WHERE( id=NEW.edit_origin_id OR edit_origin_id=NEW.edit_origin_id) ORDER BY id DESC LIMIT 1))-NEW.edit_dist)/LENGTH((SELECT description FROM edits WHERE( id=NEW.edit_origin_id OR edit_origin_id=NEW.edit_origin_id) ORDER BY id DESC LIMIT 1)));
