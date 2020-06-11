CREATE TRIGGER session_update
AFTER UPDATE ON `session`
FOR EACH ROW
BEGIN
  IF new.status = 1 THEN
    UPDATE event SET status = 1 WHERE tournamentid = new.tournamentid;
  ELSEIF new.status = 2 THEN
    UPDATE event SET status = (SELECT min(status) FROM `session` WHERE tournamentid = new.tournamentid) WHERE event.tournamentid = new.tournamentid;
  END IF;
END;%



CREATE TRIGGER match_update
AFTER UPDATE ON `match`
FOR EACH ROW
BEGIN
  IF new.status = 1 THEN
    UPDATE session SET status = 1 WHERE sessionid = new.sessionid;
  ELSEIF new.status = 2 THEN
    UPDATE session SET status = (SELECT min(status) FROM `match` WHERE sessionid = new.sessionid) WHERE sessionid = new.sessionid;
  END IF;
END;%
