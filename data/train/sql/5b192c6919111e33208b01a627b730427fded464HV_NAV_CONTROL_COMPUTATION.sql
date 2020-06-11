
  CREATE OR REPLACE  VIEW HV_NAV_CONTROL_COMPUTATION (SCHEME, SCHCLASS, SCH_AUM_CR, SCH_UNITS_CR, AUM_CR, UNITS_CR, NAV, TOTAL_EXPENSE, PLANWISE_INCOME, MGMT_RECUR_EXP, NET_ADDITION_PLANWISE, NAV_MOV, MANUAL_CURRENT_DAY_NAV, FINAL_MANUAL_CURRENT_DAY_NAV, WKNAV_SCHEME, WEEKEND_DT, NAV_DATE, SCHEME_NAME, NAME, TOTAL_INCOME, BUY_NAV_VALUE, SELL_NAV_VALUE, PORTFOLIO_TYPE, PORTFOLIO_CATEGORY, PER_MGMT_RECUR_EXP, DIVIDEND, MISSED_VALUE, PORTFOLIO_CAT_NAME_ALT, PORT_CAT_ALT, SCHEMENAME, LAST_NAV) AS 
 SELECT hv_aum_units_nav.SCHEME,
  hv_aum_units_nav.SCHCLASS,
  SCH_AUM.SCH_AUM_Cr,
  SCH_AUM.SCH_UNITS_Cr,
  ROUND((hv_aum_units_nav.LNA             /10000000),8) AUM_Cr,
  ROUND((NVL(hv_aum_units_nav.ACNT_UNIT,0)/10000000),8) UNITS_Cr,
  ROUND(hv_aum_units_nav.NAV,8) NAV,
  HV_TOTAL_EXPENSE.TOTAL_EXPENSE,
  -- ROUND( (( NVL(SUM (HV_SCHEME_INCOME.TOTAL_AMOUNT),0)* ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr),8)/10000000 PLANWISE_INCOME,--By Gaurav to suppres Divisor by zero
  DECODE(SCH_AUM.SCH_AUM_Cr,0,0,ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0)* ROUND((hv_aum_units_nav.LNA/10000000),8))/ SCH_AUM.SCH_AUM_Cr),8)/10000000)PLANWISE_INCOME,
  --(-((hv_aum_units_nav.LNA/10000000) + ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0) * ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr),8)/10000000)* NVL( HV_TOTAL_EXPENSE.TOTAL_EXPENSE,0))/365 MGMT_RECUR_EXP,--By Gaurav to suppres Divisor by zero
  --DECODE(SCH_AUM.SCH_AUM_Cr,0,0,(-((hv_aum_units_nav.LNA/10000000) + ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0) * ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr),8)/10000000)* NVL( HV_TOTAL_EXPENSE.TOTAL_EXPENSE,0))/365) MGMT_RECUR_EXP,comment by gaurav
   round(DECODE(SCH_AUM.SCH_AUM_Cr,0,0,(-((hv_aum_units_nav.LNA/10000000) +ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0) * ROUND((hv_aum_units_nav.LNA/10000000),8))/ SCH_AUM.SCH_AUM_Cr),8)/10000000)*(CASE
    WHEN (SUBSTR(hv_aum_units_nav.schclass,LENGTH(hv_aum_units_nav.schclass)-1,2))='DP'
    THEN HV_TOTAL_EXPENSE.total_expense -HV_TOTAL_EXPENSE.DP
    ELSE HV_TOTAL_EXPENSE.total_expense
  END )))/365/100,8) MGMT_RECUR_EXP,
  --(ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0)          * ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr),8)/10000000) + -((hv_aum_units_nav.LNA/10000000) + ((( ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr)/10000000))* (NVL( HV_TOTAL_EXPENSE.TOTAL_EXPENSE,0)/365) NET_ADDITION_PLANWISE,--By Gaurav to suppres Divisor by zero
  --DECODE(SCH_AUM.SCH_AUM_Cr,0,0,(ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0) * ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr),8)/10000000) + -((hv_aum_units_nav.LNA/10000000) + ((( ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr)/10000000))* (NVL( HV_TOTAL_EXPENSE.TOTAL_EXPENSE,0)/365)) NET_ADDITION_PLANWISE,
 ROUND( DECODE(SCH_AUM.SCH_AUM_Cr,0,0,ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0)* ROUND((hv_aum_units_nav.LNA/10000000),8))/ SCH_AUM.SCH_AUM_Cr),8)/10000000)+DECODE(SCH_AUM.SCH_AUM_Cr,0,0,(-((hv_aum_units_nav.LNA/10000000) +ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0) * ROUND((hv_aum_units_nav.LNA/10000000),8))/ SCH_AUM.SCH_AUM_Cr),8)/10000000)*
  (CASE
    WHEN (SUBSTR(hv_aum_units_nav.schclass,LENGTH(hv_aum_units_nav.schclass)-1,2))='DP'
    THEN HV_TOTAL_EXPENSE.total_expense -HV_TOTAL_EXPENSE.DP
    ELSE HV_TOTAL_EXPENSE.total_expense
  END )))/365/100,5)+(hnm.missed_value)NET_ADDITION_PLANWISE,
  --ROUND(( (ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0)  * ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr),8)/10000000) + -((hv_aum_units_nav.LNA/10000000) + ((( ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr)/10000000))* (NVL( HV_TOTAL_EXPENSE.TOTAL_EXPENSE,0)/365))/(NVL(hv_aum_units_nav.ACNT_UNIT,0)/10000000),8) NAV_MOV,--By Gaurav to suppres Divisor by zero
  DECODE(SCH_AUM.SCH_AUM_Cr,0,0,ROUND(( (ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0) * ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr),8)/10000000) + -((hv_aum_units_nav.LNA/10000000) + ((( ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr)/10000000))* ((NVL( HV_TOTAL_EXPENSE.TOTAL_EXPENSE,0)/365)/100))/(NVL(hv_aum_units_nav.ACNT_UNIT,0)/10000000),8))NAV_MOV,
  --(ROUND(( (ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0) * ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr),8)/10000000) + -((hv_aum_units_nav.LNA/10000000) + ((( ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr)/10000000))* (NVL( HV_TOTAL_EXPENSE.TOTAL_EXPENSE,0)/365))/(NVL(hv_aum_units_nav.ACNT_UNIT,0)/10000000),8)+ hv_aum_units_nav.LAST_NAV) MANUAL_CURRENT_DAY_NAV,--By Gaurav to suppres Divisor by zero
  DECODE(SCH_AUM.SCH_AUM_Cr,0,0,(ROUND(( (ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0) * ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr),8)/10000000) + -((hv_aum_units_nav.LNA/10000000) + ((( ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr)/10000000))* (NVL( HV_TOTAL_EXPENSE.TOTAL_EXPENSE,0)/365))/(NVL(hv_aum_units_nav.ACNT_UNIT,0)/10000000),8)+ hv_aum_units_nav.LAST_NAV)) MANUAL_CURRENT_DAY_NAV,
  DECODE(SCH_AUM.SCH_AUM_Cr,0,0,(ROUND(( (ROUND( (( NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0) * ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr),8)/10000000) + -((hv_aum_units_nav.LNA/10000000) + ((( ROUND((hv_aum_units_nav.LNA/10000000),5))/ SCH_AUM.SCH_AUM_Cr)/10000000))* (NVL( HV_TOTAL_EXPENSE.TOTAL_EXPENSE,0)/365))/(NVL(hv_aum_units_nav.ACNT_UNIT,0)/10000000),8)+ hv_aum_units_nav.LAST_NAV-(NVL(HAND.EX_DIVIDEND_NAV,0)))) Final_Manual_Current_Day_NAV,
  hv_aum_units_nav.WKNAV_SCHEME,
  hv_aum_units_nav.WEEKEND_DT,
  hv_aum_units_nav.WEEKEND_DT+1 nav_date,
  hv_aum_units_nav.SCHEME_NAME ,
  hv_aum_units_nav.NAME,
  NVL(SUM(HV_SCHEME_INCOME.TOTAL_AMOUNT),0) Total_income,
  hv_aum_units_nav.buy_nav_value,
  hv_aum_units_nav.sell_nav_value,
  hv_aum_units_nav.portfolio_type,
  hv_aum_units_nav. portfolio_category,
   CASE
    WHEN (SUBSTR(hv_aum_units_nav.schclass,LENGTH(hv_aum_units_nav.schclass)-1,2))='DP'
    THEN HV_TOTAL_EXPENSE.total_expense                                     -HV_TOTAL_EXPENSE.DP
    ELSE HV_TOTAL_EXPENSE.total_expense
  END Per_MGMT_RECUR_EXP,
  /*substr(hv_aum_units_nav.schclass,LENGTH(hv_aum_units_nav.schclass)-1,2) test1,
  case when hv_aum_units_nav.schclass in('DX','DH','DY','WDM','WDD','WDQ','WGR','WDI','DD','DI','DM','DQ','GR','PDD','PRD','PRG')Test Block----Gaurav
  then HV_TOTAL_EXPENSE.total_expense else (HV_TOTAL_EXPENSE.total_expense-HV_TOTAL_EXPENSE.DP)/100 end  Per_MGMT_RECUR_exps*/
  HAND.EX_DIVIDEND_NAV DIVIDEND,
  hnm.missed_value,
  salt.schemetypetwo portfolio_cat_name_alt,
  salt.schemetype port_cat_alt,
  salt.schemename,
  hv_aum_units_nav.last_nav
FROM hv_aum_units_nav,HUPD_NAV_MISSED HNM,hm_scheme_alt salt,
  HUPD_NAV_DIVIDEND HAND,
  HV_SCHEME_INCOME HV_SCHEME_INCOME,
  (SELECT hv_aum_units_nav1.SCHEME,
    SUM(ROUND((NVL(hv_aum_units_nav1.LNA,0)      /10000000),8)) SCH_AUM_Cr,
    SUM(ROUND((NVL(hv_aum_units_nav1.ACNT_UNIT,0)/10000000),8)) SCH_UNITS_Cr,
    hv_aum_units_nav1.WEEKEND_DT
  FROM hv_aum_units_nav hv_aum_units_nav1
  GROUP BY SCHEME,
    WEEKEND_DT
  ) SCH_AUM,
  HV_TOTAL_EXPENSE HV_TOTAL_EXPENSE
WHERE hv_aum_units_nav.SCHEME   = HV_TOTAL_EXPENSE.SCHEME
AND hv_aum_units_nav.SCHEME     =hand.scheme(+)
AND hv_aum_units_nav.schclass   =hand.plan(+)
and hv_aum_units_nav.SCHEME   =salt.schemecode
and hnm.scheme=hv_aum_units_nav.SCHEME 
and hnm.plan=hv_aum_units_nav.schclass
AND hv_aum_units_nav.WEEKEND_DT = SCH_AUM.WEEKEND_DT
AND hv_aum_units_nav.SCHEME     = SCH_AUM.SCHEME
AND HV_SCHEME_INCOME.SCHEME     = hv_aum_units_nav.SCHEME
GROUP BY hv_aum_units_nav.SCHEME,
  SCH_AUM.SCH_AUM_Cr,
  SCH_AUM.SCH_UNITS_Cr,
  hv_aum_units_nav.LAST_NET_ASSETS ,
  hv_aum_units_nav.LNA ,
  hv_aum_units_nav.NAV ,
  hv_aum_units_nav.LAST_NAV,
  hv_aum_units_nav.WKNAV_SCHEME,
  hv_aum_units_nav.SCHCLASS,
  hv_aum_units_nav.WEEKEND_DT,
  hv_aum_units_nav.SCHEME_NAME ,
  HV_TOTAL_EXPENSE.TOTAL_EXPENSE,
  hv_aum_units_nav.NAME,
  hv_aum_units_nav.ACNT_UNIT,
  buy_nav_value,
  hv_aum_units_nav.sell_nav_value,
  hv_aum_units_nav.portfolio_type,
  hv_aum_units_nav. portfolio_category,
  HV_TOTAL_EXPENSE.DP,
  HAND.EX_DIVIDEND_NAV,
   hnm.missed_value,
   salt.schemetypetwo,
   salt.schemetype,
   salt.schemename,
   hv_aum_units_nav.last_nav;
 
