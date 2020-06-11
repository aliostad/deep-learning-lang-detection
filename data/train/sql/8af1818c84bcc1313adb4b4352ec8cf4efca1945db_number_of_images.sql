SET NOCOUNT ON

SELECT '* fb images' AS 'What', 
       (SELECT Count(*) 
        FROM   [entity] 
        WHERE  new_path_c != '' 
               AND ententitytypeid NOT IN ( 0, 24 ))  AS 'Total'
UNION 
SELECT '* images' AS 'What', 
       (SELECT Count(*) 
        FROM   [entity] 
        WHERE  new_path_c != '' 
               AND ententitytypeid NOT IN ( 0, 24 )) * 2 + (SELECT Count(*) 
                                                            FROM   [entity] 
                                                            WHERE 
       new_path_c != '' 
       AND ententitytypeid 
           = 0) + (SELECT 
       Count(*) 
                  FROM 
       [entity] 
                  WHERE 
       new_path_c != '' 
       AND ententitytypeid = 24)  AS 'Total'
UNION 
SELECT '* max id'       AS 'What', 
       Max(ententityid) AS 'Total' 
FROM   [entity] 
WHERE  new_path_c != '' 