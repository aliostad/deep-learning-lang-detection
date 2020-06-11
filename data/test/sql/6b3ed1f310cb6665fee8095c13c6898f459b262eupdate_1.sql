-- 
-- Скрипт сгенерирован Devart dbForge Studio for MySQL, Версия 6.2.280.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/mysql/studio
-- Дата скрипта: 07.10.2014 13:08:18
-- Версия сервера базы данных источника: 5.7.4
-- Строка соединения источника: User Id=root;Host=localhost;Port=3307;Character Set=utf8
-- Версия сервера базы данных получателя: 5.5.25
-- Строка соединения получателя: User Id=root;Host=localhost;Character Set=utf8
-- Выполните скрипт в базу old_wot, чтобы синхронизировать ее с базой wotdb
-- Пожалуйста, сохраните резервную копию вашей базы получателя перед запуском этого скрипта
-- 


--
-- Отключение внешних ключей
--
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

SET NAMES 'utf8';

--
-- Создать таблицу "armor"
--
CREATE TABLE armor (
  column1 VARCHAR(255) DEFAULT NULL,
  player_name VARCHAR(255) DEFAULT NULL,
  column3 VARCHAR(255) DEFAULT NULL,
  column4 VARCHAR(255) DEFAULT NULL,
  bronesite DECIMAL(10, 2) DEFAULT NULL,
  column6 VARCHAR(255) DEFAULT NULL,
  UNIQUE INDEX UK_armor_player_name (player_name)
)
ENGINE = INNODB
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Изменить таблицу "wot_player"
--
ALTER TABLE wot_player
  ADD COLUMN bronesite DECIMAL(10, 2) DEFAULT NULL AFTER wn8;

--
-- Изменить таблицу "wot_player_history"
--
ALTER TABLE wot_player_history
  ADD COLUMN bronesite DECIMAL(10, 2) DEFAULT NULL AFTER wn8;

--
-- Изменить таблицу "wot_tank"
--
ALTER TABLE wot_tank
  DROP INDEX UK_wot_tank_tank_name,
  CHANGE COLUMN tank_name tank_name VARCHAR(100) NOT NULL;

DELIMITER $$

--
-- Изменить триггер "tr_wot_player_achievment_update"
--
DROP TRIGGER IF EXISTS tr_wot_player_achievment_update$$
CREATE TRIGGER tr_wot_player_achievment_update
	AFTER UPDATE
	ON wot_player_achievment
	FOR EACH ROW
BEGIN
  IF old.cnt<>new.cnt THEN
    INSERT INTO wot_player_achievment_history (updated_at, player_id, achievment_id, cnt)
      VALUES (new.updated_at, new.player_id, new.achievment_id, new.cnt)
    ON DUPLICATE KEY UPDATE cnt = new.cnt;
  END IF;
END
$$

--
-- Изменить триггер "tr_wot_player_statistic_update"
--
DROP TRIGGER IF EXISTS tr_wot_player_statistic_update$$
CREATE TRIGGER tr_wot_player_statistic_update
	AFTER UPDATE
	ON wot_player_statistic
	FOR EACH ROW
BEGIN
  IF new.battles<>old.battles THEN
    INSERT INTO wot_player_statistic_history (player_id
    , statistic_id
    , updated_at
    , spotted
    , hits
    , battle_avg_xp
    , draws
    , wins
    , losses
    , capture_points
    , battles
    , damage_dealt
    , hits_percents
    , damage_received
    , shots
    , xp
    , frags
    , survived_battles
    , dropped_capture_points)
      VALUES (new.player_id, new.statistic_id, new.updated_at, new.spotted, new.hits, new.battle_avg_xp, new.draws, new.wins, new.losses, new.capture_points, new.battles, new.damage_dealt, new.hits_percents, new.damage_received, new.shots, new.xp, new.frags, new.survived_battles, new.dropped_capture_points)
    ON DUPLICATE KEY UPDATE
    spotted = new.spotted,
    hits = new.hits,
    battle_avg_xp = new.battle_avg_xp,
    draws = new.draws,
    wins = new.wins,
    losses = new.losses,
    capture_points = new.capture_points,
    battles = new.battles,
    damage_dealt = new.damage_dealt,
    hits_percents = new.hits_percents,
    damage_received = new.damage_received,
    shots = new.shots,
    xp = new.xp,
    frags = new.frags,
    survived_battles = new.survived_battles,
    dropped_capture_points = new.dropped_capture_points;
  END IF;
END
$$

--
-- Изменить триггер "tr_wot_player_tank_update"
--
DROP TRIGGER IF EXISTS tr_wot_player_tank_update$$
CREATE TRIGGER tr_wot_player_tank_update
	AFTER UPDATE
	ON wot_player_tank
	FOR EACH ROW
BEGIN
  SET @updated_at = (SELECT
    updated_at
  FROM wot_player wp
  WHERE wp.player_id = new.player_id);
    IF ((@updated_at IS NOT NULL) AND (new.battles>old.battles)) THEN
        INSERT INTO wot_player_tank_history (updated_at
        , player_id
        , tank_id
        , max_xp
        , wins
        , battles
        , max_frags
        , mark_of_mastery
        , in_garage)
          VALUES (@updated_at, new.player_id, new.tank_id, new.max_xp, new.wins, new.battles, new.max_frags, new.mark_of_mastery, new.in_garage)
        ON DUPLICATE KEY UPDATE max_xp = new.max_xp, wins = new.wins, battles = new.battles, max_frags = new.max_frags, mark_of_mastery = new.mark_of_mastery, in_garage = new.in_garage;
  END IF;
END
$$

--
-- Изменить триггер "tr_wot_player_update"
--
DROP TRIGGER IF EXISTS tr_wot_player_update$$
CREATE TRIGGER tr_wot_player_update
	AFTER UPDATE
	ON wot_player
	FOR EACH ROW
BEGIN
    INSERT INTO wot_player_history (updated_at, player_id, max_xp, effect, wn6, wn7, wn8, bronesite)
        VALUES (new.updated_at, new.player_id, new.max_xp, new.effect, new.wn6, new.wn7, new.wn8, new.bronesite)
    ON DUPLICATE KEY UPDATE max_xp = new.max_xp, effect = new.effect, wn6 = new.wn6, wn7 = new.wn7, wn8 = new.wn8, bronesite=new.bronesite;
END
$$

--
-- Изменить триггер "wot_player_tank_statistic_update"
--
DROP TRIGGER IF EXISTS wot_player_tank_statistic_update$$
CREATE TRIGGER wot_player_tank_statistic_update
	AFTER UPDATE
	ON wot_player_tank_statistic
	FOR EACH ROW
BEGIN
  IF (new.battles<>old.battles)AND new.updated_at IS NOT NULL THEN
      INSERT INTO wot_player_tank_statistic_history (player_id
      , tank_id
      , statistic_id
      , updated_at
      , spotted
      , hits
      , battle_avg_xp
      , draws
      , wins
      , losses
      , capture_points
      , battles
      , damage_dealt
      , hits_percents
      , damage_received
      , shots
      , xp
      , frags
      , survived_battles
      , dropped_capture_points)
        VALUES (new.player_id, new.tank_id, new.statistic_id, new.updated_at, new.spotted, new.hits, new.battle_avg_xp, new.draws, new.wins, new.losses, new.capture_points, new.battles, new.damage_dealt, new.hits_percents, new.damage_received, new.shots, new.xp, new.frags, new.survived_battles, new.dropped_capture_points)
      ON DUPLICATE KEY UPDATE
      spotted = new.spotted,
      hits = new.hits,
      battle_avg_xp = new.battle_avg_xp,
      draws = new.draws,
      wins = new.wins,
      losses = new.losses,
      capture_points = new.capture_points,
      battles = new.battles,
      damage_dealt = new.damage_dealt,
      hits_percents = new.hits_percents,
      damage_received = new.damage_received,
      shots = new.shots,
      xp = new.xp,
      frags = new.frags,
      survived_battles = new.survived_battles,
      dropped_capture_points = new.dropped_capture_points;
  END IF;
END
$$

DELIMITER ;

--
-- Включение внешних ключей
--
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;