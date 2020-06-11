
  CREATE OR REPLACE  VIEW HV_INCOME_EXP (NAV_ID, FF_VC1, SCHEME, ACCENT_AMNT, PORTFOLIO_TYPE, PORTFOLIO_CATEGORY, PORTFOLIO_CATEGORY_NAME, YEAR_MONTH_ID, DAY_ID, WEEK_OF_YEAR, MONTH_ID, FISC_NUM_IND_QUARTER, YEAR_ID, PORTFOLIO_NAME, TRANS_DATE, NAV_SUM, PORTFOLIO, AVG_NAV, AVG_NAV_MON, AVG_NAV_YEAR, CNT_MN, CNT_YR) AS 
  SELECT SUM_NAV.NAV_ID,
    SUM_NAV.FF_VC1,
    ACCENT.SCHEME,
    SUM(ACCENT.AMOUNT) ACCENT_AMNT,
    SUM_NAV.PORTFOLIO_TYPE,
    SUM_NAV.PORTFOLIO_CATEGORY,
    SUM_NAV.PORTFOLIO_CATEGORY_NAME,
    DT_TIME_DIM.YEAR_MONTH_ID,
    DT_TIME_DIM.DAY_ID,
    DT_TIME_DIM.WEEK_OF_YEAR,
    DT_TIME_DIM.MONTH_ID,
    DT_TIME_DIM.FISC_NUM_IND_QUARTER,
    DT_TIME_DIM.YEAR_ID,
    sum_nav.portfolio_name,
    SUM_NAV.TRANS_DATE,
    (SUM_NAV.SNAV) NAV_SUM ,
    SUM_NAV.PORTFOLIO,
    ROUND( AVG(sum_nav.snav)over (partition BY sum_nav.portfolio order by sum_nav.trans_date),2) avg_nav,
    ROUND( AVG(sum_nav.snav)over (partition BY sum_nav.portfolio,dt_time_dim.year_month_id order by dt_time_dim.year_month_id),2) avg_nav_mon,
    ROUND( AVG(sum_nav.snav)over (partition BY sum_nav.portfolio order by dt_time_dim.year_id),2) avg_nav_year,
    count(sum_nav.snav)over (partition by sum_nav.portfolio,dt_time_dim.year_month_id order by dt_time_dim.year_month_id) cnt_mn,
    COUNT(sum_nav.snav)over (partition BY sum_nav.portfolio order by dt_time_dim.year_id) cnt_yr/*,
    gl.level_1      AS gl_level,
    gl.account_name AS account_name,
    gl.CODE         AS code*/
  FROM hdim_time_cal dt_time_dim,
    hi_accent_curr accent,
   -- hi_gl_info gl,
    (SELECT HREP_NAV_SUMMARY_CURR.NAV_ID,
      HREP_NAV_SUMMARY_CURR.FF_VC1,
      HREP_NAV_SUMMARY_CURR.PORTFOLIO_NAME,
      HREP_NAV_SUMMARY_CURR.TRANS_DATE,
      SUM(HREP_NAV_SUMMARY_CURR.NET_ASSET_VALUE) SNAV ,
      HREP_NAV_SUMMARY_CURR.PORTFOLIO,
      HREP_NAV_SUMMARY_CURR.PORTFOLIO_TYPE,
      HREP_NAV_SUMMARY_CURR.PORTFOLIO_CATEGORY,
      HREP_NAV_SUMMARY_CURR.PORTFOLIO_CATEGORY_NAME
    FROM HREP_NAV_SUMMARY_CURR
    WHERE HREP_NAV_SUMMARY_CURR.UNITS_OUTS     > 0
    AND HREP_NAV_SUMMARY_CURR.PORTFOLIO_CLASS <> 'GLOBAL'
      --AND   HREP_NAV_SUMMARY_CURR.PORTFOLIO = 'APR24MT112'
    --AND HREP_NAV_SUMMARY_CURR.TRANS_DATE BETWEEN '01 APR 2013' AND ' 30 NOV 2013'
    GROUP BY HREP_NAV_SUMMARY_CURR.NAV_ID,
      HREP_NAV_SUMMARY_CURR.FF_VC1,
      HREP_NAV_SUMMARY_CURR.PORTFOLIO_NAME,
      HREP_NAV_SUMMARY_CURR.TRANS_DATE,
      HREP_NAV_SUMMARY_CURR.PORTFOLIO,
      HREP_NAV_SUMMARY_CURR.PORTFOLIO_TYPE,
      HREP_NAV_SUMMARY_CURR.PORTFOLIO_CATEGORY,
      HREP_NAV_SUMMARY_CURR.PORTFOLIO_CATEGORY_NAME
    ORDER BY HREP_NAV_SUMMARY_CURR.TRANS_DATE
    ) SUM_NAV
  WHERE SUM_NAV.TRANS_DATE = DT_TIME_DIM.DAY_END_DATE
  AND (ACCENT.LEVEL_1     IN ('810300','810311'))
  AND (ACCENT.NARRATION NOT LIKE '%lumpsum')
  AND accent.scheme = sum_nav.portfolio
  --and (accent.value_date between '1 APR 2013' and '30 NOV 2013')
 -- AND gl.scheme = accent.scheme
    -- and gl.LEVEL_1 = ACCENT.LEVEL_1
    --AND gl.type   = SUM_NAV.PORTFOLIO_CATEGORY_NAME
  GROUP BY SUM_NAV.NAV_ID,
    SUM_NAV.FF_VC1,
    ACCENT.SCHEME,
    SUM_NAV.PORTFOLIO_TYPE,
    SUM_NAV.PORTFOLIO_CATEGORY,
    SUM_NAV.PORTFOLIO_CATEGORY_NAME,
    DT_TIME_DIM.YEAR_MONTH_ID,
    DT_TIME_DIM.DAY_ID,
    DT_TIME_DIM.WEEK_OF_YEAR,
    DT_TIME_DIM.MONTH_ID,
    DT_TIME_DIM.FISC_NUM_IND_QUARTER,
    DT_TIME_DIM.YEAR_ID,
    SUM_NAV.PORTFOLIO_NAME,
    SUM_NAV.TRANS_DATE,
    sum_nav.snav ,
    sum_nav.portfolio/*,
    gl.level_1,
    gl.account_name ,
    gl.code*/
  ORDER BY SUM_NAV.TRANS_DATE;
 
