

USE games_storage;

-- create
CREATE TABLE topics (id INT,
                        name CHAR(50),
                        isNew BOOL
                    );

-- index
ALTER TABLE topics
  ADD INDEX (id);

-- insert
INSERT INTO topics (id, name, isNew) VALUES (0, 'Без темы',         1);
INSERT INTO topics (id, name, isNew) VALUES (1, 'Новость',           1);
INSERT INTO topics (id, name, isNew) VALUES (2, 'Проблема',           1);
INSERT INTO topics (id, name, isNew) VALUES (3, 'Обсуждение',        1);
INSERT INTO topics (id, name, isNew) VALUES (4, 'Жалоба',         1);
INSERT INTO topics (id, name, isNew) VALUES (5, 'Предложение',        1);
INSERT INTO topics (id, name, isNew) VALUES (6, 'Администратору',      1);

-- old