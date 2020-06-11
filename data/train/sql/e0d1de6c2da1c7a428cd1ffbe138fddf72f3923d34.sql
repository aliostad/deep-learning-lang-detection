# --- !Ups
ALTER TABLE thread ADD COLUMN flash_id VARCHAR(40);
ALTER TABLE thread ADD COLUMN totem_id VARCHAR(40);
ALTER TABLE thread ADD constraint fk_totem_id foreign key (totem_id)
   references totem (id) on delete cascade;
ALTER TABLE thread ADD constraint fk_flash_id foreign key (flash_id)
   references position (id) on delete cascade;

UPDATE thread
SET totem_id=totem.id
FROM (SELECT id, activity_id
      FROM  totem) AS totem
WHERE thread.activity_id=totem.activity_id;

# --- !Downs
ALTER TABLE thread DROP flash_id;
ALTER TABLE thread DROP totem_id;
