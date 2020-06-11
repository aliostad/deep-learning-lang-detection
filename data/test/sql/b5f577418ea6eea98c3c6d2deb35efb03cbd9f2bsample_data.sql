INSERT INTO "UZYTKOWNIK"("nazwa_uzytkownika") VALUES 
('JB'), 
('GP'), 
('KOWALCP4');

INSERT INTO "EKSPERYMENTY_DOSTEP"("id_uzytkownika", "sesja_id") VALUES
 (1,1),
 (1,1),
 (2,2),
 (3,3),
 (1,4), 
 (2,4);

INSERT INTO "SESJA_POMIAROWA"("nazwa_id") VALUES
 (1),
 (1),
 (1),
 (2),
 (3);

INSERT INTO "EKSPERYMENT"("nazwa") VALUES 
('EKSPERYMENT COMPTONA'), 
('PRAWO OHMA'), 
('OGNIWA PELTIERA');

INSERT INTO "SERIE" ("sesja_id", "data", "wynik") VALUES
(1, now(), '{ "betaArray": {"value": [0, 1, 2], "pragma": "transient"}}');

INSERT INTO "SERIE" ("sesja_id", "data", "wynik") VALUES
(1, now(), '{ "betaArray": {"value": [0, 1, 2], "pragma": "replace"}, "constants": {"value": [3.1415], "pragma": "append"}}');
INSERT INTO "SERIE" ("sesja_id", "data", "wynik") VALUES
(1, now(), '{ "betaArray": {"value": [3, 4, 5], "pragma": "append"}, "constants": {"value": [2.73], "pragma": "append"}, "state": {"value":"in progress", "pragma":"transient"}}');
INSERT INTO "SERIE" ("sesja_id", "data", "wynik") VALUES
(1, now(), '{ "betaArray": {"value": [6, 7, 8], "pragma": "append"}, "constants": {"value": [3.1415, 1], "pragma": "append"}}');
INSERT INTO "SERIE" ("sesja_id", "data", "wynik") VALUES
(2, now(), '{ "betaArray": {"value": [3, 4, 5], "pragma": "append"}, "constants": {"value": [3.1415], "pragma": "append"}}');
INSERT INTO "SERIE" ("sesja_id", "data", "wynik") VALUES
(4, now(), '{"current": {"value": [5.12, 9, 14, 103], "pragma": "replace"}, "voltage": {"value": [6.2, 4, 3.1, 0.3], "pragma": "replace"}}' );
INSERT INTO "SERIE" ("sesja_id", "data", "wynik") VALUES
(4, now(), '{"current": {"value": [1.1, 2.2, 3.3], "pragma": "append"}, "voltage": {"value": [7.2, 8.2, 9.2], "pragma": "append"}, "unknown": {"value": [666], "pragma":"append"}}');
INSERT INTO "SERIE" ("sesja_id", "data", "wynik") VALUES
(5, now(), '{"current": {"value": [5.12, 9, 14, 103], "pragma": "replace"}, "voltage": {"value": [6.2, 4, 3.1, 0.3], "pragma": "replace"}, "temp": {"value": [25.2,24.5, 23.5, 22.7],"pragma":"replace"}}');

--SELECT (nazwa, wynik) FROM "SERIE" join "SESJA_POMIAROWA" on ("SESJA_POMIAROWA".id = "SERIE".sesja_id) join "EKSPERYMENT" on ("EKSPERYMENT".id = "SESJA_POMIAROWA".nazwa_id);
SELECT wynik FROM "SERIE"
