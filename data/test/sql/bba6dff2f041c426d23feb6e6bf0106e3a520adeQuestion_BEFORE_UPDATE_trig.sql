DELIMITER //
DROP TRIGGER IF EXISTS Question_BEFORE_UPDATE_trig//
CREATE TRIGGER Question_BEFORE_UPDATE_trig
BEFORE UPDATE ON Question
FOR EACH ROW BEGIN
    INSERT INTO QuestionHistory (QuestionHistoryId, QuestionId, QuestionClientId, DisplayText, Explanation, QuestionClientImage, IsApprovedForUse, IsActive, LastModifiedBy,DateCreated)
    VALUES (DEFAULT, OLD.QuestionId, OLD.QuestionClientId, OLD.DisplayText, OLD.Explanation, OLD.QuestionClientImage, OLD.IsApprovedForUse, OLD.IsActive, OLD.LastModifiedBy, NOW());
END//
DELIMITER ;