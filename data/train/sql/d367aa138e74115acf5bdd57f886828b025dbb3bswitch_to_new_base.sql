INSERT INTO cube_directory.card 
SELECT * FROM card_directory.card;
INSERT INTO cube_directory.cube 
SELECT * FROM card_directory.cube;
INSERT INTO cube_directory.wizards_set 
SELECT * FROM card_directory.wizards_set;
INSERT INTO cube_directory.users 
SELECT * FROM card_directory.users;

insert into cube_directory.cube_card_use (cardUse, version, cardId)
select old.cardUse, old.version, old.card_id as cardId from card_directory.cube_card_use old;

insert into cube_directory.card_in_cube (cubeId, concreteCard_id, cardId)
select old.cube_id as cubeId, old.concreteCard_id, old.card_id as cardId from card_directory.card_in_cube old;

insert into cube_directory.card_in_set (setId, rarity, cardId)
select old.set_id as setId, old.rarity, old.card_id as cardId from card_directory.card_in_set old;

insert into cube_directory.card_model (mcLink, printing, cardInSet_id)
select old.mcLink, old.printing, cis.id as cardInSet_id from card_directory.card_model old, cube_directory.card_in_set cis
where old.cardInSet_card_id = cis.cardId and old.cardInSet_set_id = cis.setId;

insert into cube_directory.model_price (date, high, low, mid, cardModel_id)
select old.date, old.high, old.low, old.mid, cm.id as cardModel_id
from card_directory.model_price old, cube_directory.card_model cm, cube_directory.card_in_set cis, card_directory.card_model oldCm
where oldCm.cardInSet_card_id = cis.cardId and oldCm.cardInSet_set_id = cis.setId 
and cis.id = cm.cardInSet_id 
and oldCm.id = old.cardModel_id;
