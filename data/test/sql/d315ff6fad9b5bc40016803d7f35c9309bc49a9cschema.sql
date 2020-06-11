CREATE TABLE models (
id INTEGER PRIMARY KEY,
name TEXT,
created
);

CREATE TABLE characters (
id INTEGER PRIMARY KEY,
model_id INTEGER,
character TEXT,
created
);

CREATE TABLE strokes (
id INTEGER PRIMARY KEY,
character_id INTEGER,
strokes TEXT,
created
);

INSERT INTO models (name,created) values ('number', '2011/12/13');

INSERT INTO characters(model_id,character, created) values(1,'0','2011/12/13');
INSERT INTO characters(model_id,character, created) values(1,'1','2011/12/13');
INSERT INTO characters(model_id,character, created) values(1,'2','2011/12/13');
INSERT INTO characters(model_id,character, created) values(1,'3','2011/12/13');
INSERT INTO characters(model_id,character, created) values(1,'4','2011/12/13');
INSERT INTO characters(model_id,character, created) values(1,'5','2011/12/13');
INSERT INTO characters(model_id,character, created) values(1,'6','2011/12/13');
INSERT INTO characters(model_id,character, created) values(1,'7','2011/12/13');
INSERT INTO characters(model_id,character, created) values(1,'8','2011/12/13');
INSERT INTO characters(model_id,character, created) values(1,'9','2011/12/13');

INSERT INTO models (name,created) values ('alphabet', '2011/12/13');

INSERT INTO characters(model_id,character, created) values(2,'A','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'B','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'C','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'D','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'E','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'F','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'G','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'H','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'I','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'J','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'K','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'L','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'M','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'N','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'O','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'P','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'Q','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'R','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'S','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'T','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'U','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'V','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'W','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'X','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'Y','2011/12/13');
INSERT INTO characters(model_id,character, created) values(2,'Z','2011/12/13');
