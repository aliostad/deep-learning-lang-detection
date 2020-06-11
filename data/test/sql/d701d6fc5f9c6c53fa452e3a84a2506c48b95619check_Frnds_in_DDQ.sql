select 
			snsdb_new.data_download_queue.priority,
			snsdb_new.data_download_queue.state,
			COUNT(snsdb_new.data_download_queue.id) as count_profiles 
from 
			snsdb_new.data_download_queue
INNER JOIN 
			(
			SELECT snsdb_new.data_download_queue.sns_item_id as _SNS_ID,
							-- snsdb_new.data_download_queue.id as _ID,
							-- snsdb_new.data_download_queue.priority as _PRIORITY,
							-- snsdb_new.data_download_queue.state as _STATE,
							min(snsdb_new.data_download_queue.created) as _MIN_DATE
			FROM snsdb_new.data_download_queue
			GROUP BY snsdb_new.data_download_queue.sns_item_id 
								-- ,snsdb_new.data_download_queue.id
			) as TempTable_1 ON snsdb_new.data_download_queue.sns_item_id = TempTable_1._SNS_ID 
											AND snsdb_new.data_download_queue.created = TempTable_1._MIN_DATE 
INNER JOIN 
			paydb.sns_profiles ON (snsdb_new.data_download_queue.sns_item_id = paydb.sns_profiles.sns_profile_id)

GROUP BY 
			snsdb_new.data_download_queue.priority,
			snsdb_new.data_download_queue.state
ORDER BY 
			snsdb_new.data_download_queue.priority DESC,
			snsdb_new.data_download_queue.state DESC
;
select count(*) from paydb.sns_profiles