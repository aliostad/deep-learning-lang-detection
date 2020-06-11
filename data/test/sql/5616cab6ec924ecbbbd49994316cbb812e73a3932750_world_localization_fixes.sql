LOCK TABLES `creature_names_localized` WRITE;
ALTER TABLE `creature_names_localized` collate utf8_unicode_ci;
UNLOCK TABLES;

LOCK TABLES `gameobject_names_localized` WRITE;
ALTER TABLE `gameobject_names_localized` collate utf8_unicode_ci;
UNLOCK TABLES;

LOCK TABLES `itempages_localized` WRITE;
ALTER TABLE `itempages_localized` collate utf8_unicode_ci;
UNLOCK TABLES;

LOCK TABLES `npc_text_localized` WRITE;
ALTER TABLE `npc_text_localized` collate utf8_unicode_ci;
UNLOCK TABLES;

LOCK TABLES `quests_localized` WRITE;
ALTER TABLE `quests_localized` collate utf8_unicode_ci;
UNLOCK TABLES;
