ALTER TABLE PatientMedications ADD Active bit

DELETE FROM PatientMedications

INSERT INTO PatientMedications SELECT ReachID, 'Cipro', ABS(Checksum(NewID()) % 2) FROM Patient
INSERT INTO PatientMedications SELECT ReachID, 'Cephalexin', ABS(Checksum(NewID()) % 2) FROM Patient
INSERT INTO PatientMedications SELECT ReachID, 'Prednisone', ABS(Checksum(NewID()) % 2) FROM Patient
INSERT INTO PatientMedications SELECT ReachID, 'Amoxicillin', ABS(Checksum(NewID()) % 2) FROM Patient
INSERT INTO PatientMedications SELECT ReachID, 'Hydrocodone', ABS(Checksum(NewID()) % 2) FROM Patient
INSERT INTO PatientMedications SELECT ReachID, 'Furosemide', ABS(Checksum(NewID()) % 2) FROM Patient