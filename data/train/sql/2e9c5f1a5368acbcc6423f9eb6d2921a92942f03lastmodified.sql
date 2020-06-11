USE US;
GO

SET ANSI_WARNINGS OFF;
SET NOCOUNT ON;
GO

WITH agg AS
(
    SELECT
        last_user_seek,
        last_user_scan,
        last_user_lookup,
        last_user_update
    FROM
        sys.dm_db_index_usage_stats
    WHERE
        database_id = DB_ID()
)
SELECT
    last_read = MAX(last_read),
    last_write = MAX(last_write)
FROM
(
    SELECT last_user_seek, NULL FROM agg
    UNION ALL
    SELECT last_user_scan, NULL FROM agg
    UNION ALL
    SELECT last_user_lookup, NULL FROM agg
    UNION ALL
    SELECT NULL, last_user_update FROM agg
) AS x (last_read, last_write);