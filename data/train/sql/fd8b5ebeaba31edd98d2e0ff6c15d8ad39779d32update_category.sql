-- 无限分类表触发器
-- 作者：Vergil <vergil@vip.163.com>

DROP TRIGGER IF EXISTS `before_update_category`;
DROP TRIGGER IF EXISTS `after_update_category`;

DELIMITER $$

-- BEFORE UPDATE 触发器 
-- 用于更新level字段和检查新的节点是否为自己的子节点
CREATE TRIGGER `before_update_category` BEFORE UPDATE ON `category` FOR EACH ROW
BEGIN
	DECLARE lv SMALLINT;
	DECLARE c SMALLINT;
	DECLARE self_node VARCHAR(500);
	DECLARE pos INT;

	IF NEW.parent_id != OLD.parent_id THEN
		IF NEW.parent_id = 0 THEN
			SET lv = 1;	
		ELSE
			-- 检查上级节点是否自己的子节点
			SELECT `node_index` INTO self_node FROM `category_node_index` WHERE `id` = OLD.id;
			SELECT POSITION(self_node IN `node_index`), COUNT(1) INTO pos, c FROM `category_node_index` WHERE `id` = NEW.parent_id;

			IF c = 0 THEN
				-- 父节点不存在，抛出异常
				INSERT INTO `parent_id_not_exists` VALUES(1);
			END IF;

			IF pos > 0 THEN
				-- 如果新的父节点是自己的子节点
				-- 这里故意写一条错误的SQL语言让其失败抛出异常
				-- 暂时没有更好的方法，先这么写吧
				INSERT INTO `new_parent_can_not_be_a_sub_category_of_itself` VALUES(1);
			END IF;

			SELECT `level` + 1 INTO lv FROM `category` WHERE `id` = NEW.parent_id;
		END IF;
		SET NEW.level = lv;
	END IF;
END;
$$


-- AFTER UPDATE 触发器
-- 
CREATE TRIGGER `after_update_category` AFTER UPDATE ON `category` FOR EACH ROW
BEGIN
	-- 新的节点
	DECLARE new_node VARCHAR(500);
	-- 旧的节点
	DECLARE old_node VARCHAR(500);
	-- 父节点level
	DECLARE new_parent_level SMALLINT;
	IF NEW.parent_id != OLD.parent_id THEN
		SELECT `node_index` INTO old_node FROM `category_node_index` WHERE `id` = NEW.id;
		
		IF NEW.parent_id = 0 THEN
			SET new_node = CONCAT(',0,', NEW.id, ',');
			UPDATE `category_node_index` SET `node_index` = new_node WHERE `id` = NEW.id;
			UPDATE `category_node_index` SET `node_index` = CONCAT(new_node, id, ',') WHERE `node_index` LIKE CONCAT(old_node, '%') AND `id` != NEW.id;
		ELSE
			SELECT `node_index` INTO new_node FROM `category_node_index` WHERE `id` = NEW.parent_id;
			SELECT `level` INTO new_parent_level FROM `category` WHERE `id` = NEW.parent_id;

			UPDATE `category_node_index` SET `node_index` =  CONCAT(new_node, id, ',') WHERE `id` = NEW.id;
			UPDATE `category` SET `level` = `level` + (new_parent_level - NEW.level) WHERE `node_index` LIKE CONCAT(old_node, '%') AND `id` != NEW.id;
			UPDATE `category_node_index` SET `node_index` = REPLACE(`node_index`, old_node, CONCAT(new_node, id, ',')) WHERE `node_index` LIKE CONCAT(old_node, '%') AND `id` != NEW.id;
			-- UPDATE `category_node_index` SET `node_index` = CONCAT(new_node, NEW.id, ',', id, ',') WHERE `node_index` LIKE CONCAT(old_node, '%') AND `id` != NEW.id;
		END IF;
	END IF;
END;
$$

DELIMITER ;
