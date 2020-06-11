


USE dev_storage;

-- create
CREATE TABLE topics (id INT,
                        name CHAR(50),
                        isNew BOOL
                    );

-- index
ALTER TABLE topics
  ADD INDEX (id);

-- insert
INSERT INTO topics (id, name, isNew) VALUES (0, 'general',         1);
INSERT INTO topics (id, name, isNew) VALUES (1, 'Win32',            1);
INSERT INTO topics (id, name, isNew) VALUES (2, 'Unix/Linux',           1);
INSERT INTO topics (id, name, isNew) VALUES (3, 'Java',         1);
INSERT INTO topics (id, name, isNew) VALUES (4, 'Delphi',       1);
INSERT INTO topics (id, name, isNew) VALUES (5, 'Web',          1);
INSERT INTO topics (id, name, isNew) VALUES (6, 'General algo',            1);
INSERT INTO topics (id, name, isNew) VALUES (7, 'Fun',      1);
INSERT INTO topics (id, name, isNew) VALUES (8, 'Offtopic',     1);

-- old