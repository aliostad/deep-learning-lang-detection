CREATE PROCEDURE releaseReadLock(IN lockKey VARCHAR(256), IN tokenIn VARCHAR(256))
BEGIN
	DECLARE writeLockToken VARCHAR(256);
	DECLARE precursorToken VARCHAR(256);

	/* Lock on master and get the state of the write an precursor tokens */
	CALL lockOnWriteReadMaster(lockKey, writeLockToken, precursorToken);
	/* delete this read lock using its token */
	DELETE FROM WRITE_READ_LOCK WHERE LOCK_KEY = lockKey AND TOKEN = tokenIn;
	/*Count the rows affected by the delete*/
	SELECT ROW_COUNT() AS RESULT;
	COMMIT;
END;