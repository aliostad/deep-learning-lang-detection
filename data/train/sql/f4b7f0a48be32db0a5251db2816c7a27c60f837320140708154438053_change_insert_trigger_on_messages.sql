DROP TRIGGER track_inserts_of_messages;

DROP TRIGGER track_sending_of_messages;

CREATE TRIGGER track_message_send_on_insert AFTER INSERT ON messages
WHEN NEW.seq IS NULL AND NEW.is_draft = 0
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('messages', NEW.database_identifier, 0);
END;

CREATE TRIGGER track_message_send_on_update AFTER UPDATE OF is_draft ON messages
WHEN (NEW.seq IS NULL AND NEW.is_draft = 0 AND OLD.is_draft = 1)
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('messages', NEW.database_identifier, 1);
END;
