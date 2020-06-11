/* This procedure will start a new transaction and lock on the master row for the given key.  The output writeLockToken and precursorToken will be non-null if either exists and are not expired for the given lock. */
CREATE PROCEDURE lockOnWriteReadMaster(IN lockKey VARCHAR(256), OUT writeLockToken VARCHAR(256), OUT precursorToken VARCHAR(256))
BEGIN
	DECLARE lockKeyExists VARCHAR(256);
	DECLARE writeExpiresOn TIMESTAMP;

	START TRANSACTION;

	/* Lock on the master row. This will result in a gap lock if the row does not exit.*/
	SELECT 
			LOCK_KEY, WRITE_LOCK_TOKEN, PRECURSOR_TOKEN, EXPIRES_ON
		INTO lockKeyExists , writeLockToken , precursorToken , writeExpiresOn FROM
			WRITE_READ_MASTER
		WHERE
			LOCK_KEY = lockKey
		FOR UPDATE;
	
	/* If the lock key does not exist we need to create it in a new transaction to prevent deadlock */
	IF lockKeyExists IS NULL THEN
		/* Commit to release the gap lock acquired for the missing row*/
		COMMIT;
		/* Insert the new row in a new transaction */
		START TRANSACTION;
		INSERT IGNORE INTO WRITE_READ_MASTER (LOCK_KEY) VALUES (lockKey);
		COMMIT;
		/* The master row now exits, so attempt to lock on it with the new transaction. */
		START TRANSACTION;
		/* Lock on the master */
		SELECT 
			LOCK_KEY, WRITE_LOCK_TOKEN, PRECURSOR_TOKEN, EXPIRES_ON
		INTO lockKeyExists , writeLockToken , precursorToken , writeExpiresOn FROM
			WRITE_READ_MASTER
		WHERE
			LOCK_KEY = lockKey
		FOR UPDATE;
	END IF;

	/* Is the write lock expired */
	IF writeExpiresOn IS NOT NULL AND writeExpiresOn < CURRENT_TIMESTAMP THEN
		/* The lock is expired so release it. */
		UPDATE WRITE_READ_MASTER SET WRITE_LOCK_TOKEN = NULL, PRECURSOR_TOKEN = NULL, EXPIRES_ON = NULL WHERE
			LOCK_KEY = lockKey;
		/* Clear lock local variables*/
		SET writeLockToken = NULL;
		SET precursorToken = NULL;
		SET writeExpiresOn = NULL;
	END IF;

END;