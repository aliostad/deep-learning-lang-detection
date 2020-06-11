--------------------------------------------------------
--  File created - Wednesday-May-28-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View DT_TIME_DIM
--------------------------------------------------------

  CREATE OR REPLACE  VIEW DT_TIME_DIM (TRANS_DATE, DAY_ID, WEEK_OF_YEAR, MONTH_ID, FISC_NUM_IND_QUARTER, YEAR_ID) AS 
  SELECT HREP_NAV_SUMMARY_CURR.TRANS_DATE,
to_date(HDIM_TIME_CAL.DAY_ID,'DD-MM-YYYY') DAY_ID,
HDIM_TIME_CAL.WEEK_OF_YEAR,
HDIM_TIME_CAL.MONTH_ID,
HDIM_TIME_CAL.FISC_NUM_IND_QUARTER,
HDIM_TIME_CAL.YEAR_ID
FROM HREP_NAV_SUMMARY_CURR, HDIM_TIME_CAL WHERE  HREP_NAV_SUMMARY_CURR.TRANS_DATE = HDIM_TIME_CAL.DAY_END_DATE;
