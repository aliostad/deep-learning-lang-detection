USE archiprod;
DROP VIEW _view_personne;
DROP VIEW _view_partie;
DROP VIEW _view_oai_records;
DROP VIEW _view_collectivite;
DROP VIEW _view_role;
#DROP VIEW test_view_oai_records;
ALTER TABLE volume change parent parent_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE volume change technicien technicien_id int(11) NOT NULL DEFAULT '0';
ALTER TABLE partie change id id varchar(36) COLLATE latin1_general_ci NOT NULL DEFAULT '';

CREATE TABLE evenement_dump SELECT * FROM evenement; 
CREATE TABLE video_volume2 SELECT * FROM video_volume; 
CREATE TABLE volume2 SELECT * FROM volume; 
CREATE TABLE note_programme2 SELECT * FROM note_programme;