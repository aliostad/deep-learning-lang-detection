CREATE TABLE "files" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"fn"  TEXT (40),
"wc" INTEGER
);

CREATE TABLE "words" (
"id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
"sw"  TEXT (40)
);

CREATE TABLE "hits" (
"_fid"  INTEGER NOT NULL,
"_wid"  INTEGER NOT NULL,
"count" INTEGER NOT NULL,
"ratings" INTEGER NOT NULL
);

CREATE VIEW "view1" AS
SELECT
files.fn, files.wc, words.sw, hits.count, hits.ratings
FROM
files, words, hits
WHERE hits._fid = files.id and hits._wid = words.id;

CREATE TRIGGER "tr1" INSTEAD OF INSERT ON "view1"
BEGIN
INSERT INTO files (fn,wc)
SELECT NEW.fn, NEW.wc
WHERE NOT EXISTS
    (SELECT 1 FROM files
     WHERE fn = NEW.fn);

INSERT INTO words (sw)
SELECT NEW.sw
WHERE NOT EXISTS
    (SELECT 1 FROM words
     WHERE sw = NEW.sw);

INSERT INTO hits (_fid,_wid, count, ratings)
SELECT files.id, words.id, NEW.count, NEW.ratings
FROM files, words
WHERE files.fn = NEW.fn and words.sw = NEW.sw;
END;
