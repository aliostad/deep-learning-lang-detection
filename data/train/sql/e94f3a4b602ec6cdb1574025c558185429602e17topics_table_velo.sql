

USE velo_storage;

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
INSERT INTO topics (id, name, isNew) VALUES (1, 'Клуб',           1);
INSERT INTO topics (id, name, isNew) VALUES (2, 'Обсуждение',           1);
INSERT INTO topics (id, name, isNew) VALUES (3, 'Куплю',        1);
INSERT INTO topics (id, name, isNew) VALUES (4, 'Развлечения',         1);
INSERT INTO topics (id, name, isNew) VALUES (5, 'Продам',        1);
INSERT INTO topics (id, name, isNew) VALUES (6, 'F.A.Q.',      1);
INSERT INTO topics (id, name, isNew) VALUES (7, 'Велотуризм',      1);
INSERT INTO topics (id, name, isNew) VALUES (8, 'Потеряно/найдено',      1);
INSERT INTO topics (id, name, isNew) VALUES (9, 'Отзывы',      1);

-- old