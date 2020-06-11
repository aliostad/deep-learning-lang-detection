SET @NEW_REF_ENTRY  :=70000;    -- use free Reference ID
DELETE FROM `creature_loot_template` WHERE `item` IN (45656,45657,45658);
DELETE FROM `creature_loot_template` WHERE `entry`=33955 AND `mincountOrRef`=-@NEW_REF_ENTRY;
INSERT INTO `creature_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
(33955,4,100,1,0,-@NEW_REF_ENTRY,2);
DELETE FROM `reference_loot_template` WHERE `entry`=@NEW_REF_ENTRY;
INSERT INTO `reference_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES 
(@NEW_REF_ENTRY,45656,0,1,1,1,1),
(@NEW_REF_ENTRY,45657,0,1,1,1,1),
(@NEW_REF_ENTRY,45658,0,1,1,1,1);