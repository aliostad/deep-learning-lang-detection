ALTER TABLE sample
      ADD manifestId INTEGER NULL
;

ALTER TABLE sample
    ADD CONSTRAINT fk_sample_manifest FOREIGN KEY (manifestId) REFERENCES manifest(Id)
;

CREATE INDEX idx_sample_manifestId ON sample (manifestId)
;

ALTER TABLE sample_audit
      ADD manifestId INTEGER NULL
;

DROP TRIGGER trg_sample_insert;
CREATE TRIGGER trg_sample_insert AFTER INSERT ON sample
    FOR EACH ROW
    BEGIN
		INSERT INTO sample_audit(audit_action, audit_datetime, sampleId, sampleCode, volume, plateName, well, conditionDescription, dnaTest, picoTest, manifestId)
		VALUES ('INSERT NEW',NOW(),NEW.id, NEW.sampleCode, NEW.volume, NEW.plateName, NEW.well, NEW.conditionDescription, NEW.dnaTest, NEW.picoTest, NEW.manifestId);
    END
;

DROP TRIGGER trg_sample_update;
CREATE TRIGGER trg_sample_update AFTER UPDATE ON sample
    FOR EACH ROW
    BEGIN
		INSERT INTO sample_audit(audit_action, audit_datetime, sampleId, sampleCode, volume, plateName, well, conditionDescription, dnaTest, picoTest, manifestId)
		VALUES ('UPDATE OLD',NOW(),OLD.id, OLD.sampleCode, OLD.volume, OLD.plateName, OLD.well, OLD.conditionDescription, OLD.dnaTest, OLD.picoTest, OLD.manifestId);
        INSERT INTO sample_audit(audit_action, audit_datetime, sampleId, sampleCode, volume, plateName, well, conditionDescription, dnaTest, picoTest, manifestId)
        VALUES ('UPDATE NEW',NOW(),NEW.id, NEW.sampleCode, NEW.volume, NEW.plateName, NEW.well, NEW.conditionDescription, NEW.dnaTest, NEW.picoTest, NEW.manifestId);
    END
;

DROP TRIGGER trg_sample_delete;
CREATE TRIGGER trg_sample_delete AFTER DELETE ON sample
    FOR EACH ROW
    BEGIN
        INSERT INTO sample_audit(audit_action, audit_datetime, sampleId, sampleCode, volume, plateName, well, conditionDescription, dnaTest, picoTest, manifestId)
        VALUES ('DELETE OLD',NOW(),OLD.id, OLD.sampleCode, OLD.volume, OLD.plateName, OLD.well, OLD.conditionDescription, OLD.dnaTest, OLD.picoTest, OLD.manifestId);
    END
;

