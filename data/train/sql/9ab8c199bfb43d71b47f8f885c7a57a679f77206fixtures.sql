INSERT INTO schema_versions(version) VALUES (94);

INSERT INTO crispr_plate_appends_type(id) VALUES ('u6');
INSERT INTO crispr_plate_appends_type(id) VALUES ('t7-barry');
INSERT INTO crispr_plate_appends_type(id) VALUES ('t7-wendy');


INSERT INTO crispr_plate_appends (plate_id, append_id) (SELECT p.id, c.id from plates p, crispr_plate_appends_type c where p.type_id='CRISPR' and c.id='u6');


UPDATE crispr_plate_appends SET append_id='t7-barry' WHERE plate_id IN (SELECT id from plates where type_id='CRISPR' and name LIKE 'MGPR_%');

