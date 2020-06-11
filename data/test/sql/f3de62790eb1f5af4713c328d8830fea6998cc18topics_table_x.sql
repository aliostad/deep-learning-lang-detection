

--USE zlo_storage;

-- create
CREATE TABLE x_topics (
  id INT NOT NULL /*AUTO_INCREMENT*/ PRIMARY KEY,
  name CHAR(50),
  isNew BOOL
  )
ENGINE=INNODB
DEFAULT CHARSET=cp1251;

-- index
-- ALTER TABLE x_topics
--  ADD INDEX (id);

-- insert
INSERT INTO x_topics (id, name, isNew) VALUES (0, 'без темы',         1);
INSERT INTO x_topics (id, name, isNew) VALUES (1, 'Учеба',            1);
INSERT INTO x_topics (id, name, isNew) VALUES (2, 'Работа',           1);
INSERT INTO x_topics (id, name, isNew) VALUES (3, 'Мурзилка',         1);
INSERT INTO x_topics (id, name, isNew) VALUES (4, 'Обсуждение',       1);
INSERT INTO x_topics (id, name, isNew) VALUES (5, 'Новости',          1);
INSERT INTO x_topics (id, name, isNew) VALUES (6, 'Спорт',            1);
INSERT INTO x_topics (id, name, isNew) VALUES (7, 'Развлечения',      1);
INSERT INTO x_topics (id, name, isNew) VALUES (8, 'Движок борды',     1);
INSERT INTO x_topics (id, name, isNew) VALUES (9, 'Программирование', 1);
INSERT INTO x_topics (id, name, isNew) VALUES (10, 'Куплю',           1);
INSERT INTO x_topics (id, name, isNew) VALUES (11, 'Продам',          1);
INSERT INTO x_topics (id, name, isNew) VALUES (12, 'Услуги',          1);
INSERT INTO x_topics (id, name, isNew) VALUES (13, 'Windows',         1);
INSERT INTO x_topics (id, name, isNew) VALUES (14, 'BSD/Linux',       1);
INSERT INTO x_topics (id, name, isNew) VALUES (15, 'Проблемы сети',   1);
INSERT INTO x_topics (id, name, isNew) VALUES (16, 'Голосование',     1);
INSERT INTO x_topics (id, name, isNew) VALUES (17, 'Потеряно/Найдено',1);
INSERT INTO x_topics (id, name, isNew) VALUES (18, 'Temp',            1);
-- old
--INSERT INTO x_topics (id, name, isNew) VALUES (11, 'Продам/Обменяю',  0);