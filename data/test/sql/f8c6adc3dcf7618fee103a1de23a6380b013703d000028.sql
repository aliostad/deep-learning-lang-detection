ALTER TABLE batch
      ADD failed BOOLEAN NOT NULL
;

ALTER TABLE batch_audit
      ADD failed BOOLEAN NOT NULL
;

DROP TRIGGER trg_batch_insert;
CREATE TRIGGER trg_batch_insert AFTER INSERT ON batch
    FOR EACH ROW
    BEGIN
        INSERT INTO batch_audit(audit_action, audit_datetime, batchId, robot, pcrMachine, temperature, datetime, userId, version_id, plateName, halfPlate, humidity, primerBatch, enzymeBatch, rotorGene, operatorUserId, failed)
        VALUES ('INSERT NEW',NOW(),NEW.id, NEW.robot, NEW.pcrMachine, NEW.temperature, NEW.datetime, NEW.userId, NEW.version_id, NEW.plateName, NEW.halfPlate, NEW.humidity, NEW.primerBatch, NEW.enzymeBatch, NEW.rotorGene, NEW.operatorUserId, NEW.failed);
    END
;

DROP TRIGGER trg_batch_update;
CREATE TRIGGER trg_batch_update AFTER UPDATE ON batch
    FOR EACH ROW
    BEGIN
        INSERT INTO batch_audit(audit_action, audit_datetime, batchId, robot, pcrMachine, temperature, datetime, userId, version_id, plateName, halfPlate, humidity, primerBatch, enzymeBatch, rotorGene, operatorUserId, failed)
        VALUES ('UPDATE OLD',NOW(),OLD.id, OLD.robot, OLD.pcrMachine, OLD.temperature, OLD.datetime, OLD.userId, OLD.version_id, OLD.plateName, OLD.halfPlate, OLD.humidity, OLD.primerBatch, OLD.enzymeBatch, OLD.rotorGene, OLD.operatorUserId, OLD.failed);
        INSERT INTO batch_audit(audit_action, audit_datetime, batchId, robot, pcrMachine, temperature, datetime, userId, version_id, plateName, halfPlate, humidity, primerBatch, enzymeBatch, rotorGene, operatorUserId, failed)
        VALUES ('UPDATE NEW',NOW(),NEW.id, NEW.robot, NEW.pcrMachine, NEW.temperature, NEW.datetime, NEW.userId, NEW.version_id, NEW.plateName, NEW.halfPlate, NEW.humidity, NEW.primerBatch, NEW.enzymeBatch, NEW.rotorGene, NEW.operatorUserId, NEW.failed);
    END
;

DROP TRIGGER trg_batch_delete;
CREATE TRIGGER trg_batch_delete AFTER DELETE ON batch
    FOR EACH ROW
    BEGIN
        INSERT INTO batch_audit(audit_action, audit_datetime, batchId, robot, pcrMachine, temperature, datetime, userId, version_id, plateName, halfPlate, humidity, primerBatch, enzymeBatch, rotorGene, operatorUserId, failed)
        VALUES ('DELETE OLD',NOW(),OLD.id, OLD.robot, OLD.pcrMachine, OLD.temperature, OLD.datetime, OLD.userId, OLD.version_id, OLD.plateName, OLD.halfPlate, OLD.humidity, OLD.primerBatch, OLD.enzymeBatch, OLD.rotorGene, OLD.operatorUserId, OLD.failed);
    END
;
