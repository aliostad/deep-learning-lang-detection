DELIMITER //
DROP TRIGGER IF EXISTS SubscriptionType_BEFORE_UPDATE_trig//
CREATE TRIGGER SubscriptionType_BEFORE_UPDATE_trig
BEFORE UPDATE ON SubscriptionType
FOR EACH ROW BEGIN
    INSERT INTO SubscriptionTypeHistory (SubscriptionTypeId, HasFARModule, HasAUDModule, HasBECModule, HasREGModule, CurrentPrice, StripePlanId, IsPublic, IsActive, DateCreated)
    VALUES (OLD.SubscriptionTypeId, OLD.HasFARModule, OLD.HasAUDModule, OLD.HasBECModule, OLD.HasREGModule, OLD.CurrentPrice, OLD.StripePlanId, OLD.IsPublic, OLD.IsActive, NOW());
END//
DELIMITER ;