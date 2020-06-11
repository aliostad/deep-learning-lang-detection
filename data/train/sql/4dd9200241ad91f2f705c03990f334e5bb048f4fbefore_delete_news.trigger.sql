CREATE TRIGGER `news_after_delete` AFTER DELETE ON `news`
 FOR EACH ROW BEGIN
   DELETE FROM `access_relations`
      WHERE `type` = 'news' AND `id` = OLD.id;
   IF OLD.parentType = 'event' THEN
      DELETE FROM `event` WHERE id = OLD.parentId;
         DELETE FROM `access_relations`
            WHERE `type` = 'event' AND `id` = OLD.parentId;
         DELETE FROM `access_relations`
            WHERE `type` = 'signup' AND `id` = OLD.parentId;
      DELETE FROM `signup` WHERE eventId = OLD.parentId;
   END IF;
END
