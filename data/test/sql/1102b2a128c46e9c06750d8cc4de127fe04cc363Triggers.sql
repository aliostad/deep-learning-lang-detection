CREATE TRIGGER ChangeIncidentDecision
  AFTER INSERT ON alex.criminalcase
  REFERENCING NEW AS NEW
  FOR EACH ROW MODE DB2SQL
  UPDATE alex.incident SET alex.incident.decision = 'Возбудить уголовное дело'
    WHERE alex.incident.registrationnumber = NEW.registrationnumber;
	
CREATE TRIGGER DeleteIncidentDecision
  AFTER DELETE ON alex.criminalcase
  REFERENCING OLD AS OLD
  FOR EACH ROW MODE DB2SQL
  UPDATE alex.incident SET alex.incident.decision = 'Не возбуждать уголовное дело'
    WHERE alex.incident.registrationnumber = OLD.registrationnumber;
	
CREATE TRIGGER ReplacePerson
  AFTER INSERT ON alex.incidentinvolvment
  REFERENCING NEW AS NEW
  FOR EACH ROW MODE DB2SQL
  DELETE FROM alex.incidentinvolvment WHERE
  alex.incidentinvolvment.personnumber = NEW.personnumber
  AND alex.incidentinvolvment.registrationnumber = NEW.registrationnumber
  AND alex.incidentinvolvment.statusnumber != NEW.statusnumber;