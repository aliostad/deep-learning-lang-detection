# Dump of table buildings
# ------------------------------------------------------------

CREATE TABLE `buildings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` text,
  `location` text,
  `description` text,
  `thumbURI` text,
  `stateid` bigint(20),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# Dump of table state
# ------------------------------------------------------------

CREATE TABLE `state` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# Dump of table rooms
# ------------------------------------------------------------

CREATE TABLE `rooms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` text,
  `thumbURI` varchar(20),
  `buildingid` bigint(20),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# Dump of table photos
# ------------------------------------------------------------

CREATE TABLE `photos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` text,
  `photoURI` text,
  `roomid` bigint(20),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# Dump of view builds
# ------------------------------------------------------------

CREATE VIEW `builds` (
  `bname`,
  `blocation`,
  `bid`,
  `bstate`,
  `stid`
) AS 	SELECT b.name as bname, b.location as blocation, b.id as bid, s.name as bstate, s.id as stid
		FROM buildings b, state s
		WHERE b.stateid = s.id;
