
  CREATE OR REPLACE  VIEW HV_UPLOAD_IV (SCHEME, SCHCLASS, TRANTYPE, VALUE_DATE, NAV, NAV_UNITS, AMOUNT, LOAD, UPR_AMT, EQ_AMT, TDS, STT_TAX, BANK_ACCOUNT, DD_CHARGES, SCH_AMC, SCHEME_TYPE) AS 
  SELECT 'HDFCMS'      AS scheme,
    h.nav_schemeclass  AS schclass ,
    'RDIV'             AS trantype,
    h.nav_wkend_dt     AS value_date,
    h.nav              AS nav,
    h.nav_units        AS nav_units,
    h.corp_dd_dr       AS amount,
    0                  AS load ,
    0                  AS upr_amt,
    0                  AS eq_amt ,
    0                  AS tds ,
    0                  AS stt_tax,
    '110100-BNK15-INR' AS bank_account ,
    0                  AS dd_charges ,
    'I'                AS sch_amc ,
    'Corporate'        AS scheme_type
  FROM HI_DIVIDEND h
  UNION ALL
  SELECT 'HDFCMS'      AS scheme,
    h.nav_schemeclass  AS schclass ,
    'RDIV'             AS trantype,
    h.nav_wkend_dt     AS value_date,
    h.nav              AS nav,
    h.nav_units        AS nav_units,
    h.INDV_DD_DR       AS amount,
    0                  AS load ,
    0                  AS upr_amt,
    0                  AS eq_amt ,
    0                  AS tds ,
    0                  AS stt_tax,
    '110100-BNK15-INR' AS bank_account ,
    0                  AS dd_charges ,
    'I'                AS sch_amc ,
    'Individual'       as scheme_type
  from HI_DIVIDEND h;
 
