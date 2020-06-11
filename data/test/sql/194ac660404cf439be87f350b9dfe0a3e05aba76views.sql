DROP VIEW IF EXISTS `view_current_year`;
CREATE VIEW `view_current_year` AS
    SELECT *
    FROM `year`
    ORDER BY `id_year` DESC
    LIMIT 1;

DROP VIEW IF EXISTS `view_team`;
CREATE VIEW `view_team` AS
    SELECT `team`.*
    FROM `team`
    INNER JOIN `view_current_year` USING(`id_year`)
    ORDER BY `category`, `name`;

DROP VIEW IF EXISTS `view_serie`;
CREATE VIEW `view_serie` AS
    SELECT `serie`.*
    FROM `serie`
    INNER JOIN `view_current_year` USING(`id_year`);

DROP VIEW IF EXISTS `view_competitor`;
CREATE VIEW `view_competitor` AS
SELECT `competitor`.`id_competitor` AS `id_competitor`,`competitor`.`id_team` AS `id_team`,`competitor`.`id_school` AS `id_school`,`competitor`.`name` AS `name`,`competitor`.`inserted` AS `inserted`,`competitor`.`updated` AS `updated`,`school`.`name` AS `school_name`,`team`.`name` AS `team_name`,`team`.`category` AS `category` from ((`competitor` join `team` on((`competitor`.`id_team` = `team`.`id_team`))) left join `school` on((`competitor`.`id_school` = `school`.`id_school`))) order by `team`.`category`,`team`.`name`,`competitor`.`name`;

DROP VIEW IF EXISTS `view_task`;
CREATE VIEW `view_task` AS
	SELECT
		`task`.*,
		CASE `task`.`type`
			WHEN 'logical' THEN CONCAT('L',`task`.`number`)
			WHEN 'programming' THEN CONCAT('P', `task`.`number`)
			WHEN 'idea' THEN CONCAT('S', `task`.`number`)
		END AS `code_name`,
		`serie`.`to_show` AS `serie_to_show`
	FROM `task`
	INNER JOIN `serie` USING(`id_serie`)
	INNER JOIN `view_current_year` USING(`id_year`)
	ORDER BY `task`.`id_serie`, `task`.`id_task`;

DROP VIEW IF EXISTS `view_avaiable_task`;
CREATE VIEW `view_avaiable_task` AS
	SELECT
		`view_task`.*
	FROM `view_task`
	WHERE `serie_to_show` <= NOW()
	ORDER BY `view_task`.`id_serie`, `view_task`.`id_task`;

DROP VIEW IF EXISTS `view_answer`;
CREATE VIEW `view_answer` AS
    SELECT `answer`.*
    FROM `answer`
    INNER JOIN `task` USING(`id_task`)
    INNER JOIN `serie` USING(`id_serie`)
    INNER JOIN `view_current_year` USING(`id_year`);

DROP VIEW IF EXISTS `view_correct_answer`;
CREATE VIEW `view_correct_answer` AS
	SELECT
		`answer`.*
	FROM `view_answer` AS `answer`
	INNER JOIN `task` USING(`id_task`)
	WHERE `answer`.`code` = `task`.`code`
	GROUP BY `id_answer`;

DROP VIEW IF EXISTS `view_incorrect_answer`;
CREATE VIEW `view_incorrect_answer` AS
	SELECT
		`answer`.*
	FROM `view_answer` AS `answer`
	WHERE `answer`.`id_answer` NOT IN (SELECT `id_answer` FROM `view_correct_answer`);

DROP VIEW IF EXISTS `view_bonus_help`;
CREATE VIEW `view_bonus_help` AS
	SELECT
		`answer`.`id_team`,
		COUNT(`answer`.`id_answer`) AS `count`
	FROM `view_task` AS `task`
	LEFT JOIN `view_correct_answer` AS `answer` USING(`id_task`)
	WHERE `answer`.`id_team` IS NOT NULL
	GROUP BY `answer`.`id_team`, `task`.`type`;

DROP VIEW IF EXISTS `view_bonus`;
CREATE VIEW `view_bonus` AS
	SELECT
		`id_team`,
		IF (COUNT(*) = 3,MIN(`count`),0)*500 AS `score`
	FROM `view_bonus_help`
	GROUP BY `id_team`;

DROP VIEW IF EXISTS `view_penality`;
CREATE VIEW `view_penality` AS
	SELECT
		`team`.`id_team`,
		10*COUNT(`view_incorrect_answer`.`id_answer`) AS `score`
	FROM `view_team` AS `team`
	LEFT JOIN `view_incorrect_answer` USING(`id_team`)
	GROUP BY `id_team`;

DROP VIEW IF EXISTS `view_task_result`;
CREATE VIEW `view_task_result` AS
	SELECT
		`team`.`id_team`,
		`view_task`.`id_task`,
		`answer`.`inserted`,
		(
			IF(
				`answer`.`inserted` IS NULL,
				0,
				1000-(SELECT COUNT(`help`.`id_answer`) FROM `view_correct_answer` AS `help` WHERE `help`.`inserted` < `answer`.`inserted` AND `help`.`id_task` = `view_task`.`id_task`)
			)
		) AS `score`
	FROM (`view_team` AS `team`, `view_avaiable_task` AS `view_task`)
	LEFT JOIN `view_correct_answer` AS `answer` USING(`id_task`, `id_team`);

DROP VIEW IF EXISTS `view_total_result`;
CREATE VIEW `view_total_result` AS
	SELECT
		`team`.*,
		SUM(`view_task_result`.`score`) + IFNULL(`view_bonus`.`score`,0) - `view_penality`.`score` AS `score`
	FROM `view_team` AS `team`
	LEFT JOIN `view_task_result` USING(`id_team`)
	LEFT JOIN `view_penality` USING(`id_team`)
	LEFT JOIN `view_bonus` USING(`id_team`)
	GROUP BY `id_team`
	ORDER BY `score` DESC;

DROP VIEW IF EXISTS `view_task_stat`;
CREATE VIEW `view_task_stat` AS
	SELECT
		`view_avaiable_task`.*,
		MIN(`view_correct_answer`.`inserted`) AS `best_time`,
		MAX(`view_correct_answer`.`inserted`) AS `worst_time`,
		FROM_UNIXTIME(AVG(UNIX_TIMESTAMP(`view_correct_answer`.`inserted`))) AS `avg_time`,
		COUNT(`view_correct_answer`.`id_answer`) AS `count_correct_answer`,
		IFNULL((SELECT COUNT(`view_incorrect_answer`.`id_answer`) FROM `view_incorrect_answer` WHERE `view_incorrect_answer`.`id_task` = `view_avaiable_task`.`id_task` GROUP BY `view_incorrect_answer`.`id_task`),0) AS `count_incorrect_answer`
	FROM `view_avaiable_task`
	LEFT JOIN `view_correct_answer` USING(`id_task`)
	GROUP BY `view_avaiable_task`.`id_task`
	ORDER BY `view_avaiable_task`.`id_serie`, `view_avaiable_task`.`id_task`;

DROP VIEW IF EXISTS `view_chat`;
CREATE VIEW `view_chat` AS
	SELECT
		`chat`.*,
		`team`.`name` AS `team_name`
	FROM `chat`
	INNER JOIN `view_team` AS `team` USING(`id_team`)
	ORDER BY `chat`.`inserted` DESC;
