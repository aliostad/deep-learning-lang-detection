DELIMITER //
DROP TRIGGER IF EXISTS AccountUser_BEFORE_UPDATE_trig//
CREATE TRIGGER AccountUser_BEFORE_UPDATE_trig
BEFORE UPDATE ON AccountUser
FOR EACH ROW BEGIN
    INSERT INTO AccountUserHistory (AccountUserId, LoginName, LoginPassword, ContactEmail, IsEnabled, IsPasswordReset, IsSuspended, IsDeactivated, DateLastModified, LastModifiedBy, DateCreated)
    VALUES (OLD.AccountUserId, OLD.LoginName, OLD.LoginPassword, OLD.ContactEmail, OLD.IsEnabled, OLD.IsPasswordReset, OLD.IsSuspended, OLD.IsDeactivated, OLD.DateLastModified, OLD.LastModifiedBy, NOW());
END//
DELIMITER ;