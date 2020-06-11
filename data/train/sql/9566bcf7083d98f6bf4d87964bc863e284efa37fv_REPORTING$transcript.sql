USE KIPP_NJ
GO

ALTER VIEW REPORTING$transcript AS

WITH roster AS (
  SELECT co.student_number
        ,co.studentid
        ,co.year
        ,co.schoolid
        ,co.exitdate
        ,co.cohort        
        ,co.grade_level
        ,co.highest_achieved
        ,co.enroll_status
        ,co.first_name
        ,co.last_name
        ,co.MIDDLE_NAME        
        ,co.DOB
        ,co.HOME_PHONE
        ,co.STREET
        ,co.CITY
        ,co.STATE
        ,co.ZIP        
        ,ROW_NUMBER() OVER(
           PARTITION BY co.student_number
             ORDER BY co.year DESC) AS rn_curr
  FROM KIPP_NJ..COHORT$identifiers_long#static co WITH(NOLOCK)
  WHERE co.grade_level BETWEEN 5 AND 12
    AND co.rn = 1
 )

,naviance AS (
  SELECT [hs_student_id]      
        ,[email]
        ,[home_phone]
        ,[mobile_phone]
        ,CASE WHEN [street_address] = 'NULL' THEN NULL ELSE street_address END AS street_address
        ,CASE WHEN [street_address2] = 'NULL' THEN NULL ELSE street_address2 END AS street_address2
        ,CASE WHEN [city] = 'NULL' THEN NULL ELSE city END AS city
        ,CASE WHEN [state] = 'NULL' THEN NULL ELSE state END AS state
        ,CASE WHEN [zip] = 'NULL' THEN NULL ELSE zip END AS zip
        ,CASE WHEN [counselor_name] = 'NULL' THEN NULL ELSE counselor_name END AS counselor_name
        ,ROW_NUMBER() OVER(
           PARTITION BY hs_student_id
             ORDER BY hs_student_id) AS rn
  FROM [KIPP_NJ].[dbo].[AUTOLOAD$NAVIANCE_students] WITH(NOLOCK)
 )

,emails AS (
  SELECT dir.displayName
        ,dir.mail
  FROM KIPP_NJ..PEOPLE$AD_users#static dir WITH(NOLOCK)
  WHERE dir.is_active = 1
   AND dir.is_student = 0  
 )

SELECT r.student_number      
      ,r.year
      ,r.schoolid      
      ,r.cohort
      ,CASE 
        WHEN r.cohort <= KIPP_NJ.dbo.fn_Global_Academic_Year() AND r.enroll_status != 2 THEN FORMAT(r.exitdate,'MMMM dd, yyy') 
        ELSE CONCAT('June ', r.cohort)
       END AS grad_date
      ,CONCAT(r.first_name + ' ', r.middle_name + ' ', r.last_name) AS full_name      
      ,FORMAT(r.dob,'MM/dd/yyyy') AS DOB
      ,nav.email AS student_email
      ,COALESCE(nav.home_phone, r.home_phone) AS home_phone
      ,nav.mobile_phone AS student_mobile
      ,CASE
        WHEN nav.street_address IS NULL THEN CONCAT(r.street, CHAR(10), r.city + ', ', r.state + ' ', r.zip)
        WHEN CONCAT(nav.street_address, ' ' + nav.street_address2) + CHAR(10) + nav.city + ', ' + nav.state + ' ' + nav.zip IS NULL
             THEN CONCAT(r.street, CHAR(10), r.city + ', ', r.state + ' ', r.zip)
        ELSE CONCAT(nav.street_address, ' ' + nav.street_address2, CHAR(10), nav.city + ', ', nav.state + ' ', nav.zip)
       END AS full_address      
      ,nav.counselor_name
      ,emails.mail AS counselor_email
      ,gr.academic_year_header_yr_1
      ,gr.academic_year_header_yr_2
      ,gr.academic_year_header_yr_3
      ,gr.academic_year_header_yr_4
      ,gr.academic_year_header_yr_5
      ,gr.academic_year_header_yr_6
      ,gr.course_list_yr_1
      ,gr.course_list_yr_2
      ,gr.course_list_yr_3
      ,gr.course_list_yr_4
      ,gr.course_list_yr_5
      ,gr.course_list_yr_6
      ,gpa.GPA_header
      ,gpa.GPA_grouped
      ,test.ACT_header
      ,test.ACT_grouped
      ,test.SAT_header
      ,test.SAT_grouped
      ,cc.academic_year_header_cur
      ,cc.course_list_cur      
FROM roster r 
LEFT OUTER JOIN naviance nav WITH(NOLOCK)
  ON r.student_number = nav.hs_student_id
 AND nav.rn = 1
LEFT OUTER JOIN KIPP_NJ..REPORTING$transcript_grades_wide gr WITH(NOLOCK)
  ON r.studentid = gr.STUDENTID
 AND r.schoolid = gr.schoolid
LEFT OUTER JOIN KIPP_NJ..REPORTING$transcript_GPA_wide gpa WITH(NOLOCK)
  ON r.student_number = gpa.student_number
 AND r.schoolid = gpa.schoolid
LEFT OUTER JOIN KIPP_NJ..REPORTING$transcript_tests_wide test WITH(NOLOCK)
  ON r.student_number = test.student_number
LEFT OUTER JOIN KIPP_NJ..REPORTING$transcript_current_classes_wide cc WITH(NOLOCK)
  ON r.studentid = cc.studentid
LEFT OUTER JOIN emails
  ON nav.counselor_name = emails.displayName
WHERE r.rn_curr = 1 