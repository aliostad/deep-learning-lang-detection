CREATE TABLE IF NOT EXISTS `queries` (
  `sql` TEXT UNIQUE NOT NULL,
  `executions` INTEGER UNSIGNED DEFAULT 1,
  `clock` FLOAT UNSIGNED NOT NULL,
  `fullscan_step` INTEGER UNSIGNED,
  `sort` INTEGER UNSIGNED
);

CREATE TRIGGER IF NOT EXISTS `queries_insert`
  BEFORE INSERT ON `queries`
  WHEN (SELECT COUNT(*) FROM `queries` WHERE `sql` = NEW.`sql`) > 0
  BEGIN
    UPDATE `queries`
      SET
        `executions` = `executions` + 1,
        `clock` = `clock` + NEW.`clock`,
        `fullscan_step` = `fullscan_step` + NEW.`fullscan_step`,
        `sort` = `sort` + NEW.`sort`
      WHERE `sql` = NEW.`sql`;
    SELECT RAISE(IGNORE);
  END;
