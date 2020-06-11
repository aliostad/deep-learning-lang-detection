CREATE TABLE "eventapp_participant_log" (
    "mod_type" char(1),
    "mod_timestamp" timestamp default CURRENT_TIMESTAMP,
    "id" varchar(11),
    "entryid" varchar(11),
    "firstname" varchar(50),
    "surname" varchar(50),
    "club" varchar(7),
    "si" numeric(9, 0),
    "simode" varchar(1),
    "cls" varchar(10),
    "laps" varchar(50),
    "note" text,
    "accomid" varchar(11),
    "accommcount" smallint,
    "accommnights" smallint,
    "accommnote" text,
    "accommfee" numeric(10, 2),
    "entryfee" numeric(10, 2),
    "sifee" numeric(10, 2),
    "created" timestamp with time zone,
    "modified" timestamp with time zone
);

CREATE RULE eventapp_participant_delete AS ON DELETE TO eventapp_participant DO
INSERT INTO eventapp_participant_log VALUES (
    'D',
    CURRENT_TIMESTAMP,
    old.id,
    old.entryid,
    old.firstname,
    old.surname,
    old.club,
    old.si,
    old.simode,
    old.cls,
    old.laps,
    old.note,
    old.accomid,
    old.accommcount,
    old.accommnights,
    old.accommnote,
    old.accommfee,
    old.entryfee,
    old.sifee,
    old.created,
    old.modified
);

CREATE RULE eventapp_participant_update AS ON UPDATE TO eventapp_participant DO
INSERT INTO eventapp_participant_log VALUES (
    'U',
    CURRENT_TIMESTAMP,
    old.id,
    old.entryid,
    old.firstname,
    old.surname,
    old.club,
    old.si,
    old.simode,
    old.cls,
    old.laps,
    old.note,
    old.accomid,
    old.accommcount,
    old.accommnights,
    old.accommnote,
    old.accommfee,
    old.entryfee,
    old.sifee,
    old.created,
    old.modified
);

