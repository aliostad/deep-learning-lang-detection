DROP VIEW sicht_kv;
CREATE VIEW sicht_kv AS SELECT Mitgliedsnummer, Titel, Vorname, Nachname, Stabü, Beitrag, Straße_1, PLZ, Ort, Ortsteil, eMail_1, Wahlkreis, Lwahlkreis, Land, "geburts_datum_TT.MM.JJJJ", Bundesland, Landkreis, Kreisverband, Ortsverband, eintritts_datum, bemerkungsfeld, Telefon_1, "Fax 1"
 FROM ungesperrte;

DROP VIEW ungesperrte;
CREATE VIEW ungesperrte AS SELECT * from semkol WHERE SPERRE = "";

DROP VIEW gesperrte;
CREATE VIEW gesperrte AS SELECT * from semkol WHERE SPERRE != "";

DROP VIEW hildesheim;
CREATE VIEW hildesheim AS SELECT * from ungesperrte WHERE Kreisverband = "Hildesheim";
