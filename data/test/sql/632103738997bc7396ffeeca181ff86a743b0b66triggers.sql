-- Ensures that the inserted rows are correct.
-- Updates the field modified of an updated row.
-- Inserts the id of the deleted rows in the table delete.

-----------------------------
-- Accounts
-----------------------------
CREATE TRIGGER "insert_accounts" AFTER INSERT ON accounts
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_accounts') WHERE NEW.name='' OR NEW.administrator NOT IN (0, 1) OR NEW.active NOT IN (0, 1);
END;

CREATE TRIGGER "update_accounts" AFTER UPDATE ON accounts
BEGIN
    SELECT RAISE(ROLLBACK, 'update_accounts') WHERE NEW.name='' OR NEW.administrator NOT IN (0, 1) OR NEW.active NOT IN (0, 1);
    UPDATE accounts SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_accounts" BEFORE DELETE ON accounts
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('accounts', OLD.id);
END;

-----------------------------
-- Accounts_groups
-----------------------------
CREATE TRIGGER "update_accounts_groups" AFTER UPDATE ON accounts_groups
BEGIN
    UPDATE accounts_groups SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_accounts_groups" BEFORE DELETE ON accounts_groups
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('accounts_groups', OLD.id);
END;

-----------------------------
-- Accounts_informations
-----------------------------
CREATE TRIGGER "insert_accounts_informations" AFTER INSERT ON accounts_informations
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_accounts_informations') WHERE NEW.name='' OR NEW.value='';
END;

CREATE TRIGGER "update_accounts_informations" AFTER UPDATE ON accounts_informations
BEGIN
    SELECT RAISE(ROLLBACK, 'update_accounts_informations') WHERE NEW.name='' OR NEW.value='';
    UPDATE accounts_informations SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_accounts_informations" BEFORE DELETE ON accounts_informations
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('accounts_informations', OLD.id);
END;

-----------------------------
-- Collections
-----------------------------
CREATE TRIGGER "insert_collections" AFTER INSERT ON collections
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_collections') WHERE NEW.name='';
END;

CREATE TRIGGER "update_collections" AFTER UPDATE ON collections
BEGIN
    SELECT RAISE(ROLLBACK, 'update_collections') WHERE NEW.name='' OR NEW.id == NEW.id_collection;
    UPDATE collections SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_collections" BEFORE DELETE ON collections
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('collections', OLD.id);
END;

-----------------------------
-- Directories
-----------------------------
CREATE TRIGGER "insert_directories" AFTER INSERT ON directories
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_directories') WHERE NEW.name='';
END;

CREATE TRIGGER "update_directories" AFTER UPDATE ON directories
BEGIN
    SELECT RAISE(ROLLBACK, 'update_directories') WHERE NEW.name='' OR NEW.id == NEW.id_directory;
    UPDATE directories SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_directories" BEFORE DELETE ON directories
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('directories', OLD.id);
END;

-----------------------------
-- Events
-----------------------------
CREATE TRIGGER "insert_events" AFTER INSERT ON events
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_events') WHERE NEW.name='';
END;

CREATE TRIGGER "update_events" AFTER UPDATE ON events
BEGIN
    SELECT RAISE(ROLLBACK, 'update_events') WHERE NEW.name='';
    UPDATE events SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_events" BEFORE DELETE ON events
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('events', OLD.id);
END;

-----------------------------
-- Events_informations
-----------------------------
CREATE TRIGGER "insert_events_informations" AFTER INSERT ON events_informations
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_events_informations') WHERE NEW.name='' OR NEW.value='';
END;

CREATE TRIGGER "update_events_informations" AFTER UPDATE ON events_informations
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_events_informations') WHERE NEW.name='' OR NEW.value='';
    UPDATE events_informations SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_events_informations" BEFORE DELETE ON events_informations
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('events_informations', OLD.id);
END;

-----------------------------
-- Files
-----------------------------
CREATE TRIGGER "insert_files" AFTER INSERT ON files
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_files') WHERE NEW.name='' OR NEW.path='';
END;

CREATE TRIGGER "update_files" AFTER UPDATE ON files
BEGIN
    SELECT RAISE(ROLLBACK, 'update_files') WHERE NEW.name='' OR NEW.path='';
    UPDATE files SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_files" BEFORE DELETE ON files
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('files', OLD.id);
END;

-----------------------------
-- Files_collections
-----------------------------
CREATE TRIGGER "update_files_collections" AFTER UPDATE ON files_collections
BEGIN
    UPDATE files_collections SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_files_collections" BEFORE DELETE ON files_collections
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('files_collections', OLD.id);
END;

-----------------------------
-- Files_informations
-----------------------------
CREATE TRIGGER "insert_files_informations" AFTER INSERT ON files_informations
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_files_informations') WHERE NEW.name='' OR NEW.value='';
END;

CREATE TRIGGER "update_files_informations" AFTER UPDATE ON files_informations
BEGIN
    SELECT RAISE(ROLLBACK, 'update_files_informations') WHERE NEW.name='' OR NEW.value='';
    UPDATE files_informations SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_files_informations" BEFORE DELETE ON files_informations
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('files_informations', OLD.id);
END;

-----------------------------
-- Groups
-----------------------------
CREATE TRIGGER "insert_groups" AFTER INSERT ON groups
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_groups') WHERE NEW.name='';
END;

CREATE TRIGGER "update_groups" AFTER UPDATE ON groups
BEGIN
    SELECT RAISE(ROLLBACK, 'update_groups') WHERE NEW.name='' OR NEW.id == NEW.id_group;
    UPDATE groups SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_groups" BEFORE DELETE ON groups
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('groups', OLD.id);
END;

-----------------------------
-- Limits
-----------------------------
CREATE TRIGGER "insert_limits" AFTER INSERT ON limits
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_limits') WHERE NEW.name='' OR NEW.value='';
END;

CREATE TRIGGER "update_limits" AFTER UPDATE ON limits
BEGIN
    SELECT RAISE(ROLLBACK, 'update_limits') WHERE NEW.name='' OR NEW.value='';
    UPDATE limits SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_limits" BEFORE DELETE ON limits
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('limits', OLD.id);
END;

-----------------------------
-- Permissions
-----------------------------
CREATE TRIGGER "insert_permissions" AFTER INSERT ON permissions
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_permissions') WHERE NEW.granted NOT IN (0, 1);
END;

CREATE TRIGGER "update_permissions" AFTER UPDATE ON permissions
BEGIN
    SELECT RAISE(ROLLBACK, 'update_permissions') WHERE NEW.granted NOT IN (0, 1);
    UPDATE permissions SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_permissions" BEFORE DELETE ON permissions
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('permissions', OLD.id);
END;

-----------------------------
-- Sessions
-----------------------------
CREATE TRIGGER "update_sessions" AFTER UPDATE ON sessions
BEGIN
    UPDATE sessions SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

-----------------------------
-- Sessions_informations
-----------------------------
CREATE TRIGGER "insert_sessions_informations" AFTER INSERT ON sessions_informations
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_sessions_informations') WHERE NEW.name='';
END;

CREATE TRIGGER "update_sessions_informations" AFTER UPDATE ON sessions_informations
BEGIN
    SELECT RAISE(ROLLBACK, 'update_sessions_informations') WHERE NEW.name='';
    UPDATE sessions_informations SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

-----------------------------
-- Tags
-----------------------------
CREATE TRIGGER "insert_tags" AFTER INSERT ON tags
BEGIN
    SELECT RAISE(ROLLBACK, 'insert_tags') WHERE NEW.name='';
END;

CREATE TRIGGER "update_tags" AFTER UPDATE ON tags
BEGIN
    SELECT RAISE(ROLLBACK, 'update_tags') WHERE NEW.name='';
    UPDATE tags SET modified = (datetime('now')) WHERE NEW.modified != (datetime('now')) AND rowid = NEW.rowid;
END;

CREATE TRIGGER "delete_tags" BEFORE DELETE ON tags
BEGIN
    INSERT INTO deleted ('table', 'id') VALUES ('tags', OLD.id);
END;
