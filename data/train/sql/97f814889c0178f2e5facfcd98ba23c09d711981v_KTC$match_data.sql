USE KIPP_NJ
GO

ALTER VIEW KTC$match_data AS
WITH act_subj AS
    (SELECT s.id AS studentid,
            a.academic_year,
            a.administration_round,
            a.administered_at,
            a.subject_area,
            a.scale_score
     FROM KIPP_NJ..ACT$test_prep_scores a
     JOIN KIPP_NJ..STUDENTS s WITH (NOLOCK)
       ON a.student_number = s.student_number
     WHERE rn_dupe = 1
       AND subject_area = 'Composite'
       AND scale_score IS NOT NULL
     ),
    best_practice_act AS
   (SELECT studentid,
           a.subject_area,
           MAX(scale_score) AS best_act
    FROM act_subj a
    GROUP BY a.studentid,
             a.subject_area
    ),
    nav_act AS
    (SELECT a.hs_student_id,
           a.composite
     FROM KIPP_NJ..AUTOLOAD$NAVIANCE_3_act_scores a
     WHERE a.composite > 0
       AND a.hs_student_id IS NOT NULL
     ),
     nav_sat AS
    (SELECT s.hs_student_id,
            CAST(s.math + s.verbal AS NUMERIC) AS sat_1600
     FROM KIPP_NJ..AUTOLOAD$NAVIANCE_2_sat_scores s
     WHERE s.math + s.verbal > 0
       AND hs_student_id IS NOT NULL
     ),
     nav_sat_equiv AS
     (SELECT hs_student_id, 
             CASE WHEN sat_1600 < 530 THEN 10 ELSE concord.act END AS act_equiv
      FROM nav_sat
      LEFT OUTER JOIN KIPP_NJ..KTC$act_sat_concordance#dense concord
        ON nav_sat.sat_1600 = concord.SAT
     ),
     best_naviance_act AS
     (SELECT hs_student_id AS studentid,
             'Composite' AS subject_area,
             MAX(composite) AS best_act
      FROM
           (SELECT *
            FROM nav_act
            UNION 
            SELECT *
            FROM nav_sat_equiv
            ) sub
      GROUP BY hs_student_id
     ),
   best_any_act AS
  (SELECT studentid,
          'Composite' AS subject_area,
          MAX(best_act) AS best_any_act
   FROM
        (SELECT *
         FROM best_practice_act
         UNION ALL
         SELECT *
         FROM best_naviance_act
         ) sub
   GROUP BY studentid
  ),
   roster AS
  (SELECT c.studentid,
          c.lastfirst,
          c.grade_level AS cur_grade,
          c.cohort,
          CASE 
            WHEN ms.school_name IS NULL THEN 'New to NCA'
            ELSE ms.school_name
          END AS ms
   FROM KIPP_NJ..COHORT$comprehensive_long#static c
   LEFT OUTER JOIN KIPP_NJ..COHORT$middle_school_attended ms
     ON c.studentid = ms.studentid
   WHERE c.schoolid = 73253
     AND c.year = KIPP_NJ.dbo.fn_Global_Academic_Year()
     AND c.grade_level < 99
   )
SELECT TOP 100000000 roster.*,
       s.student_number,
       ktc.contact_id,
       p.best_act AS best_practice_act,
       n.best_act AS best_naviance_act,
       a.best_any_act,
       g.cumulative_Y1_gpa AS gpa
FROM roster
LEFT OUTER JOIN best_practice_act p
  ON roster.studentid = p.studentid
LEFT OUTER JOIN best_naviance_act n
  ON roster.studentid = n.studentid
LEFT OUTER JOIN best_any_act a
  ON roster.studentid = a.studentid
LEFT OUTER JOIN KIPP_NJ..GRADES$GPA_cumulative g
  ON roster.studentid = g.studentid
 AND g.schoolid = 73253
LEFT OUTER JOIN KIPP_NJ..STUDENTS s
  ON roster.studentid = s.id
LEFT OUTER JOIN AlumniMirror..vwRoster_Basic ktc
  ON s.student_number = ktc.sis_id
ORDER BY roster.cur_grade, lastfirst