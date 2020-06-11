-- Z SQL Method
-- /article17/habitatsummary/sql_methods/select_comments_read_number
<params>region
habitat
user
ms
reader</params>
SELECT habitat_comments_read.reader_user_id
FROM
  habitat_comments
  INNER JOIN habitat_comments_read ON (habitat_comments.id = habitat_comments_read.id_comment)
WHERE
  <dtml-sqltest region type=string> 
AND <dtml-sqltest habitat type=string>
AND <dtml-sqltest user type=string>
AND <dtml-sqltest name="ms" column="MS" type=string>
AND <dtml-sqltest name="reader" column="reader_user_id" type=string>