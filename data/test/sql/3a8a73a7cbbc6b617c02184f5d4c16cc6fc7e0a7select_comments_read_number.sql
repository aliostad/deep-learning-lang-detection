-- Z SQL Method
-- /article17/speciessummary/sql_methods/select_comments_read_number
<params>region
assesment_speciesname
user
ms
reader</params>
SELECT comments_read.reader_user_id
FROM
  comments
  INNER JOIN comments_read ON (comments.id = comments_read.id_comment)
WHERE
  <dtml-sqltest region type=string> 
AND <dtml-sqltest assesment_speciesname type=string>
AND <dtml-sqltest user type=string>
AND <dtml-sqltest name="ms" column="MS" type=string>
AND <dtml-sqltest name="reader" column="reader_user_id" type=string>