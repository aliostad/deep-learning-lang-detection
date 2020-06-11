CREATE DATABASE IF NOT EXISTS fst;
USE fst;

GRANT ALL PRIVILEGES ON fst.* TO 't99342'@'localhost' IDENTIFIED BY 't99342';

DROP TABLE IF EXISTS `NewToCategory`;
DROP TABLE IF EXISTS `UserLikesNew`;
DROP TABLE IF EXISTS `Category`;
DROP TABLE IF EXISTS `New`;
DROP TABLE IF EXISTS `User`;

CREATE TABLE `User` (
    id     INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(250)
    -- ...
) COLLATE 'utf8mb4_general_ci';;

CREATE TABLE `New` (
    id      INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    content VARCHAR(243)
    -- ...
) COLLATE 'utf8mb4_general_ci';

-- Если запись существует, пользователю новость нравится
CREATE TABLE `UserLikesNew` (
    userId      INT UNSIGNED,
    newId       INT UNSIGNED,
    lastLiked   BIGINT UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY pk(newId, userId),
    INDEX       userLike(userId),
    FOREIGN KEY fkLikeUser(userId) REFERENCES `User`(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    FOREIGN KEY fkLikeNew(newId) REFERENCES `New`(id) ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE `Category` (
    id      INT UNSIGNED PRIMARY KEY,
    `name`  VARCHAR(250)
    -- ...

) COLLATE 'utf8mb4_general_ci';

-- В задании не сказано, сколько категорий может иметь новость
CREATE TABLE `NewToCategory` (
    newId       INT UNSIGNED,
    categoryId  INT UNSIGNED,
    PRIMARY KEY pk(categoryId, newId),
    INDEX       newIdx(newId),
    FOREIGN KEY fkCatCat(categoryId) REFERENCES `Category`(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    FOREIGN KEY fkCatNew(newId) REFERENCES `New`(id) ON DELETE CASCADE ON UPDATE RESTRICT
);


INSERT INTO `User` VALUES
(1, 'Jane Doe'),
(2, 'John Doe');

INSERT INTO `New` VALUES
(1, 'Запущен первый искусственный спутник Земли'),
(2, 'Выход человека в открытый космос');

INSERT INTO `Category` VALUES
(1, 'Космос'),
(2, 'Люди'),
(3, 'Котики');

INSERT INTO `NewToCategory` VALUES
(1, 1),
(2, 1),
(2, 2);

INSERT INTO `UserLikesNew` VALUES
(1, 1, UNIX_TIMESTAMP()),
(1, 2, UNIX_TIMESTAMP());