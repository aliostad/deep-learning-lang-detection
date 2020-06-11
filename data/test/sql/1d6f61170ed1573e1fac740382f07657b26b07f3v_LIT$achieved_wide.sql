USE KIPP_NJ
GO

ALTER VIEW LIT$achieved_wide AS

SELECT studentid
      ,CONVERT(INT,[CUR_lvl_num]) - CONVERT(INT,COALESCE([DR_lvl_num],[Q1_lvl_num],[Q2_lvl_num],[Q3_lvl_num],[Q4_lvl_num])) AS lvls_grown_yr
      ,[CUR_goal_lvl]
      ,[CUR_lvl_num]
      ,[CUR_read_lvl]
      ,[CUR_gleq]
      ,[DR_goal_lvl]
      ,[DR_lvl_num]
      ,[DR_read_lvl]
      ,[Q1_goal_lvl]
      ,[Q1_lvl_num]
      ,[Q1_read_lvl]
      ,[Q2_goal_lvl]
      ,[Q2_lvl_num]
      ,[Q2_read_lvl]
      ,[Q3_goal_lvl]
      ,[Q3_lvl_num]
      ,[Q3_read_lvl]
      ,[Q4_goal_lvl]
      ,[Q4_lvl_num]
      ,[Q4_read_lvl]                     
      ,[BOY_lvl_num]
      ,[BOY_read_lvl]
      ,[BOY_gleq]
      ,[MOY_lvl_num]
      ,[MOY_read_lvl]
      ,[MOY_gleq]
      ,[EOY_lvl_num]
      ,[EOY_read_lvl]      
      ,[EOY_gleq]      
FROM
    (
     SELECT STUDENTID
           ,CONCAT(test_round, '_', field) AS pivot_field
           ,value
     FROM
         (
          SELECT studentid
                ,test_round      
                ,CONVERT(VARCHAR,read_lvl) AS read_lvl
                ,CONVERT(VARCHAR,lvl_num) AS lvl_num
                ,CONVERT(VARCHAR,goal_lvl) AS goal_lvl
                ,CONVERT(VARCHAR,gleq) AS gleq
          FROM KIPP_NJ..LIT$achieved_by_round#static WITH(NOLOCK)
          WHERE academic_year = KIPP_NJ.dbo.fn_Global_Academic_Year()

          UNION ALL

          SELECT STUDENTID
                ,'CUR' AS test_round
                ,read_lvl
                ,lvl_num
                ,goal_lvl
                ,gleq
          FROM
              (
               SELECT studentid      
                     ,start_date
                     ,CONVERT(VARCHAR,read_lvl) AS read_lvl
                     ,CONVERT(VARCHAR,lvl_num) AS lvl_num
                     ,CONVERT(VARCHAR,goal_lvl) AS goal_lvl
                     ,CONVERT(VARCHAR,gleq) AS gleq
                     ,ROW_NUMBER() OVER(
                        PARTITION BY Studentid
                          ORDER BY start_date DESC) AS rn
               FROM KIPP_NJ..LIT$achieved_by_round#static WITH(NOLOCK)
               WHERE academic_year = KIPP_NJ.dbo.fn_Global_Academic_Year()
                 AND CONVERT(DATE,GETDATE()) >= start_date
              ) sub
          WHERE rn = 1
         ) sub
     UNPIVOT(
       value
       FOR field IN (read_lvl, lvl_num, goal_lvl, gleq)
      ) u
    ) sub
PIVOT(
  MAX(value)
  FOR pivot_field IN ([CUR_goal_lvl]
                     ,[CUR_lvl_num]
                     ,[CUR_read_lvl]
                     ,[CUR_gleq]
                     ,[DR_goal_lvl]
                     ,[DR_lvl_num]
                     ,[DR_read_lvl]
                     ,[Q1_goal_lvl]
                     ,[Q1_lvl_num]
                     ,[Q1_read_lvl]
                     ,[Q2_goal_lvl]
                     ,[Q2_lvl_num]
                     ,[Q2_read_lvl]
                     ,[Q3_goal_lvl]
                     ,[Q3_lvl_num]
                     ,[Q3_read_lvl]
                     ,[Q4_goal_lvl]
                     ,[Q4_lvl_num]
                     ,[Q4_read_lvl]                     
                     ,[BOY_lvl_num]
                     ,[BOY_read_lvl]
                     ,[MOY_lvl_num]
                     ,[MOY_read_lvl]
                     ,[EOY_lvl_num]
                     ,[EOY_read_lvl]
                     ,[BOY_gleq]
                     ,[MOY_gleq]
                     ,[EOY_gleq])
 ) p