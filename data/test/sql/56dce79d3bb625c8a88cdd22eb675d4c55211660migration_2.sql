CREATE TABLE IF NOT EXISTS patient_identifier(identifier TEXT , patientUuid TEXT, typeUuid TEXT, isPrimaryIdentifier BOOLEAN, primaryIdentifier TEXT, extraIdentifiers TEXT, identifierJson TEXT, PRIMARY KEY(patientUuid, typeUuid));
ALTER TABLE patient ADD voided BOOLEAN;
ALTER TABLE event_log_marker rename TO event_log_marker_temp;
CREATE TABLE IF NOT EXISTS event_log_marker (markerName TEXT PRIMARY KEY, lastReadEventUuid TEXT, filters TEXT, lastReadTime DATETIME);
INSERT INTO event_log_marker(markerName, lastReadEventUuid , filters , lastReadTime ) (SELECT markerName , lastReadEventUuid , catchmentNumber , lastReadTime  FROM event_log_marker_temp);
DROP TABLE event_log_marker_temp;