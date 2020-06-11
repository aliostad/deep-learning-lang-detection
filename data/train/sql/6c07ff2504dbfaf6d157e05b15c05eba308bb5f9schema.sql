CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT,
    pass_hash TEXT);

CREATE TABLE games (id INTEGER PRIMARY KEY, name TEXT, 
    owner_id REFERENCES users(id), ctime TEXT, mtime TEXT);

CREATE TABLE periods (id INTEGER PRIMARY KEY, 
    game_id REFERENCES games(id) ON DELETE CASCADE,
    content TEXT, next INTEGER, previous INTEGER, tone TEXT,
    ctime TEXT, mtime TEXT);
    
CREATE TABLE events (id INTEGER PRIMARY KEY, 
    period_id REFERENCES periods(id) ON DELETE CASCADE,
    content TEXT, next INTEGER, previous INTEGER, tone TEXT,
    ctime TEXT, mtime TEXT);
    
CREATE TABLE scenes (id INTEGER PRIMARY KEY, 
    event_id REFERENCES events(id) ON DELETE CASCADE, 
    question TEXT, setting TEXT, answer TEXT, 
    next INTEGER, previous INTEGER, tone TEXT,
    ctime TEXT, mtime TEXT);

CREATE TABLE players (user_id REFERENCES users(id) ON DELETE CASCADE, 
    game_id REFERENCES games(id) ON DELETE CASCADE, 
    UNIQUE (user_id, game_id));

CREATE INDEX period_gameid ON periods (game_id);

CREATE INDEX event_periodid ON events (period_id);

CREATE INDEX scene_eventid ON scenes (event_id);

CREATE TRIGGER game_insert AFTER INSERT ON games BEGIN
    UPDATE games SET ctime = datetime("now") WHERE id = new.id;
    UPDATE games SET mtime = datetime("now") WHERE id = new.id;
END;

CREATE TRIGGER period_insert AFTER INSERT ON periods BEGIN 
    UPDATE periods SET next = new.id WHERE next IS new.next AND id != new.id;
    UPDATE periods SET previous = new.previous WHERE previous IS new.previous
        AND id != new.id;
    UPDATE periods SET ctime = datetime("now") WHERE id = new.id;
    UPDATE periods SET mtime = datetime("now") WHERE id = new.id;
END;

CREATE TRIGGER event_insert AFTER INSERT ON events BEGIN 
    UPDATE events SET next = new.id WHERE next IS new.next AND id != new.id;
    UPDATE events SET previous = new.previous WHERE previous IS new.previous
        AND id != new.id;
    UPDATE events SET ctime = datetime("now") WHERE id = new.id;
    UPDATE events SET mtime = datetime("now") WHERE id = new.id;
END;

CREATE TRIGGER scene_insert AFTER INSERT ON scenes BEGIN 
    UPDATE scenes SET next = new.id WHERE next IS new.next AND id != new.id;
    UPDATE scenes SET previous = new.previous WHERE previous IS new.previous
        AND id != new.id;
    UPDATE scenes SET ctime = datetime("now") WHERE id = new.id;
    UPDATE scenes SET mtime = datetime("now") WHERE id = new.id;
END;

CREATE TRIGGER game_update AFTER UPDATE ON games BEGIN
    UPDATE games SET mtime = datetime("now") WHERE id = new.id;
END;

CREATE TRIGGER period_update AFTER UPDATE ON periods BEGIN
    UPDATE games SET mtime = datetime("now") WHERE id = new.game_id;
    UPDATE periods SET mtime = datetime("now") WHERE id = new.id;
END;

CREATE TRIGGER event_update AFTER UPDATE ON events BEGIN
    UPDATE periods SET mtime = datetime("now") WHERE id = new.period_id;
    UPDATE events SET mtime = datetime("now") WHERE id = new.id;
END;

CREATE TRIGGER scene_update AFTER UPDATE ON scenes BEGIN
    UPDATE events SET mtime = datetime("now") WHERE id = new.event_id;
    UPDATE scenes SET mtime = datetime("now") WHERE id = new.id;
END;

CREATE TRIGGER period_delete AFTER DELETE ON periods BEGIN
    UPDATE games SET mtime = datetime("now") WHERE id = new.game_id;
    UPDATE periods SET next = old.next WHERE next IS old.id;
    UPDATE periods SET previous = old.previous WHERE previous IS old.id;
END;

CREATE TRIGGER event_delete AFTER DELETE ON events BEGIN
    UPDATE periods SET mtime = datetime("now") WHERE id = new.period_id;
    UPDATE events SET next = old.next WHERE next IS old.id;
    UPDATE events SET previous = old.previous WHERE previous IS old.id;
END;

CREATE TRIGGER scene_delete AFTER DELETE ON scenes BEGIN
    UPDATE events SET mtime = datetime("now") WHERE id = new.event_id;
    UPDATE scenes SET next = old.next WHERE next IS old.id;
    UPDATE scenes SET previous = old.previous WHERE previous IS old.id;
END;
