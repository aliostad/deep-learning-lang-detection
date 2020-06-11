DELIMITER $$
CREATE FUNCTION getTime(loc varchar(20),user varchar(255)) RETURNS INT
  DETERMINISTIC
BEGIN
   DECLARE userMin int;
   DECLARE closeTime time;
   DECLARE newMin int;

   SELECT minutes INTO userMin
     FROM users
     WHERE username = user;
 
   SELECT close_time INTO closeTime
     FROM closing_times
     WHERE location = loc AND dow = DAYOFWEEK(now());

   SELECT LEAST( userMin, time_to_sec(timediff(closeTime,time(now()) ))/60) INTO newMin;

   IF userMin != newMin THEN
      UPDATE users SET minutes=newMin where username=user;
   END IF;

   RETURN newMin;
END
$$


DELIMITER $$
CREATE TRIGGER check_for_close AFTER INSERT ON statistics
FOR EACH ROW
BEGIN
   DECLARE _newMin int;
   IF NEW.action = 'LOGIN' THEN
        SELECT getTime(NEW.client_location,NEW.username) INTO _newMin;
   END IF;
END;
$$


CREATE TABLE `closing_times` (
  `id` int(11) NOT NULL DEFAULT '0',
  `location` varchar(20) DEFAULT NULL,
  `dow` int(11) DEFAULT NULL,
  `close_time` time NOT NULL DEFAULT '00:00:00',
  PRIMARY KEY (`id`)
);
