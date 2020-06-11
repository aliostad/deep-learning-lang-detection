SET @date = "20140101";

SELECT
    COUNT(*) AS media_creations
FROM (
    SELECT *
    FROM logging
    WHERE
        log_type = "upload" AND
        log_action = "upload" AND
        log_timestamp BETWEEN @date AND
            DATE_FORMAT(DATE_ADD(@date, INTERVAL 1 DAY), "%Y%m%d%H%i%S")
) AS upload
LEFT JOIN logging old_upload ON
    old_upload.log_type = "upload" AND
    old_upload.log_action = "upload" AND
    old_upload.log_timestamp < @date AND
    upload.log_namespace = old_upload.log_namespace AND
    upload.log_title = old_upload.log_title
WHERE old_upload.log_id IS NULL;
