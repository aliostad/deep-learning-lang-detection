

USE sport_storage;

-- create
CREATE TABLE topics (id INT,
                        name CHAR(50),
                        isNew BOOL
                    );

-- index
ALTER TABLE topics
  ADD INDEX (id);

-- insert
INSERT INTO topics (id, name, isNew) VALUES (0, 'без темы',         1);
INSERT INTO topics (id, name, isNew) VALUES (1, 'Футбол',           1);
INSERT INTO topics (id, name, isNew) VALUES (2, 'Хоккей',           1);
INSERT INTO topics (id, name, isNew) VALUES (3, 'Баскетбол',        1);
INSERT INTO topics (id, name, isNew) VALUES (4, 'Волейбол',         1);
INSERT INTO topics (id, name, isNew) VALUES (5, 'Формула 1',        1);
INSERT INTO topics (id, name, isNew) VALUES (6, 'Зимние виды',      1);
INSERT INTO topics (id, name, isNew) VALUES (7, 'Летние виды',      1);
INSERT INTO topics (id, name, isNew) VALUES (8, 'Трансляция',       1);
INSERT INTO topics (id, name, isNew) VALUES (9, 'Fans',             1);
INSERT INTO topics (id, name, isNew) VALUES (10, 'Temp',            1);

-- old