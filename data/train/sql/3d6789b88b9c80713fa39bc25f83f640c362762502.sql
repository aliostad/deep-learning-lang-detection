-- D.  These questions use the table 'score', which has fields 'student_id',
--     'event_id', and 'score'.
-- 
-- 1.  Write a query returning records only for student_id 10.
-- 2.  Write a query returning records only for event_id 3.
-- 3.  Write a query returning records with scores above 15.
-- 4.  Write a query returning records with scores above 15 for event_id 5.
-- 5.  Write a query counting the number of records for each event.
-- 6.  Write a query counting the number of records for each combination of
--      values for event_id and student_id.  (HINT: Add something to the GROUP BY
--      clause.)   Is there any count greater than one?
-- 7.  Write a query averaging the score for each event.
-- 8.  Write a query averaging the score for each student.
-- 9.  Write a query reporting the count of records and average score for each event.
-- 10.  BONUS Write a query returning the standard deviation for the score for
--     each event.  (Hint: Google.)
-- 

SELECT
    *

FROM
    sampdb.score

WHERE
    event_id = 3 
;
