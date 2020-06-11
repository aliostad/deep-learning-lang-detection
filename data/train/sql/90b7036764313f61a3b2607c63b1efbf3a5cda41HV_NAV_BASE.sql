
  CREATE OR REPLACE  VIEW HV_NAV_BASE (AMFI_CODE, SCHEME, SCHEME_NAME, SCHEME_CLASS_NAME, SCHNAV_NAME, SCHEME_TYPE, SCHEME_CATEGORY, SCHEME_CAT_ALT, SCHEME_CAT_NAME_ALT, SCHEME_CLASS, MANUAL_DAY_NAV, FINAL_MANUAL_NAV, PUR_LOAD, SELL_LOAD, NAV_DATE) AS 
  SELECT 
sch.ff_vc2 amfi_code,
nac.portfolio scheme,
  nac.portfolio_name scheme_name,
  nac.portfolio_class_name scheme_class_name,
  nac.PORTFOLIO_NAME || ' ' || nac.PORTFOLIO_CLASS_NAME as schnav_name,
  nac.PORTFOLIO_TYPE scheme_type,
  nac.PORTFOLIO_CATEGORY scheme_category,
  nac.PORTFOLIO_CATEGORY_ALT scheme_cat_alt,
  nac.PORTFOLIO_CATEGORY_NAME_ALT scheme_cat_name_alt,
 -- nac.PORTFOLIO_CLASS_NAME SCHEME_CLASS_NAME,
  nac.schclass scheme_class,
  nac.last_nav +nac.nav_mov manual_day_nav,
  (nac.last_nav+nac.nav_mov)-(NVL(nac.dividend,0)) final_manual_nav,
 0 pur_load,
 0 sell_load,
  nac.nav_date
FROM HREP_NAVCONTROL_LIVE_CURR nac,hm_schclass sch
WHERE nac.portfolio=sch.scheme
and nac.schclass=sch.schclass
/*and nac.nav_date='26 NOV 2013'
and nac.portfolio='APR24MT112'*/;
 
