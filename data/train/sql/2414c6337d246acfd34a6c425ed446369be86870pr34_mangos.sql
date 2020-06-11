-- Call of the Elements/Ancestors/Spirits trainer entries
CREATE TEMPORARY TABLE new_spells (
    spell MEDIUMINT(8) UNSIGNED NOT NULL,
    spellcost INT(10) UNSIGNED NOT NULL DEFAULT 7000, /* 70 silver */
    reqskill SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0,
    reqskillvalue SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0,
    reqlevel TINYINT(3) UNSIGNED NOT NULL,
    PRIMARY KEY (spell)
);

INSERT INTO new_spells (spell, reqlevel) VALUES
(66842, 30), /* Call of the Elements */
(66843, 40), /* Call of the Ancestors */
(66844, 50); /* Call of the Spirits */

REPLACE INTO npc_trainer SELECT 986 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 3030 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 3031 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 3032 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 3066 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 3173 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 3344 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 3403 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 13417 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 17204 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 17212 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 17219 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 17519 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 17520 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 20407 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;
REPLACE INTO npc_trainer SELECT 23127 AS entry, spell, spellcost, reqskill, reqskillvalue, reqlevel FROM new_spells;

DROP TABLE new_spells;