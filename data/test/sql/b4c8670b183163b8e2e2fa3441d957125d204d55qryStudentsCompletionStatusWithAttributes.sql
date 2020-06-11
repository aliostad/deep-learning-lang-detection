SELECT 
  "view_StudentsWhoCompleted".student, 
  "view_StudentsWhoCompleted".course, 
  tbl_students.gender, 
  tbl_students.birthyear, 
  tbl_students.education, 
  tbl_students.grade, 
  tbl_students.certificate,
  "view_StudentsWhoCompleted".is_complete
FROM 
  public."view_StudentsWhoCompleted", 
  public.tbl_students
WHERE 
  "view_StudentsWhoCompleted".student = tbl_students.student AND
  "view_StudentsWhoCompleted".course = tbl_students.course
ORDER BY
  "view_StudentsWhoCompleted".student,
  "view_StudentsWhoCompleted".course