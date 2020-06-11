/*dumpcard*/


select 		'dumpcard -> DUMP_COUNT  (ID_TYPE_DATA` = 5 )'	as  O1,	
	SUM(DUMP_COUNT) 				as  C1,
	
	'dumpcard -> DUMP_COUNT  (ID_TYPE_DATA` = 5 )'	as  O2,	
	SUM(DUMP_SUM_NO_NDS) 				as  C2 

FROM `smetasourcedata` `ssd`

INNER JOIN `smetasourcedata` `ssd2` 	ON `ssd2`.`PARENT_ID` = `ssd`.`SM_ID`   AND `ssd2`.`SM_TYPE` 	= 3 

INNER JOIN `data_estimate` 	`de` 	ON `de`.`ID_ESTIMATE` = `ssd2`.`SM_ID`  

INNER JOIN `dumpcard` `dc` 		ON `dc`.`ID` = `de`.`ID_TABLES`		 AND `de`.`ID_TYPE_DATA` = 5 
 
WHERE `ssd`.`SM_ID` = :SM_ID