-- Adding an integer value for message position indicating
-- the horizon in a conversation to where the messages were
-- marked as read.
ALTER TABLE conversation_participants ADD marked_as_read_position INTEGER;
ALTER TABLE conversation_participants ADD marked_as_read_seq INTEGER;

-- Adding a trigger that tracks last read message position
-- movement for participants.
CREATE TRIGGER track_moving_last_read_message_position_of_conversation_participants AFTER UPDATE OF marked_as_read_position ON conversation_participants
WHEN NEW.marked_as_read_position IS NOT NULL AND
  (NEW.marked_as_read_position > OLD.marked_as_read_position OR
    (NEW.marked_as_read_position IS NOT NULL and OLD.marked_as_read_position IS NULL)) AND
  (NEW.marked_as_read_seq = OLD.marked_as_read_seq OR
    (NEW.marked_as_read_seq IS NULL AND OLD.marked_as_read_seq IS NULL))
BEGIN
  INSERT INTO syncable_changes(table_name, row_identifier, change_type) VALUES ('conversation_participants_last_read_position', NEW.database_identifier, 1);
END;

-- Adding an integer value for message event's position.
ALTER TABLE events ADD target_position INTEGER;
