
  CREATE OR REPLACE  VIEW HV_DIVIDEND_DISTRIBUTABLE (NAV_WKEND_DT, NAV_SCHEME, NAV_SCHEMECLASS, UPR_BALANCE, UPR, UNRELIASED_PU, NAV, UNREAL_AMOUNT, DISTRIBUTABLE_UPR, DISTRIBUTABLE) AS 
  SELECT nav_wkend_dt,
    nav_scheme,
    nav_schemeclass,
    UPR_BALANCE,
    UPR,
    UNRELIASED_PU,
    NAV,
    UNREAL_AMOUNT,
    DISTRIBUTABLE_UPR,
    case
      WHEN (distributable_upr > 0)
      THEN 'YES'
      ELSE 'NO'
    END AS distributable
  FROM
    (SELECT nav_wkend_dt,
      nav_scheme,
      nav_schemeclass,
      UPR_BALANCE,
      UPR,
      UNRELIASED_PU,
      NAV,
      UNREAL_AMOUNT,
      EX_DIVIDEND_NAV,
     least((nav-10-unreliased_pu-upr),(nav-10-upr),(nav-10) )
      as distributable_upr
    FROM
      (SELECT nav_wkend_dt,
        nav_schemeclass,
        nav_scheme,
        -- SUM(DAILY_UPR_ENTRY   + POST_UPR) UPR_BALANCE,
        hdb.DAILY_UPR_BALANCE AS UPR_BALANCE,
        --( SUM(DAILY_UPR_ENTRY + POST_UPR))/ NAV_UNITS AS UPR,
        hdb.DAILY_UPR_BALANCE / NAV_UNITS AS upr,
        CASE
          WHEN UNREAL_AMOUNT < 0
          THEN 0
          ELSE (UNREAL_AMOUNT/NAV_UNITS)
        END AS UNRELIASED_PU ,
        NAV,
        UNREAL_AMOUNT,
        ex_dividend_nav
      FROM hi_dividend hd,
        hi_daily_balance hdb
      WHERE hd.nav_wkend_dt  = hdb.VALUE_DATE
      AND hd.nav_scheme      = hdb.scheme
      and hd.nav_schemeclass = hdb.plan
      --and hd.nav_wkend_dt between '31 MAR 2013' and '08 JAN 2014'
      --AND hd.nav_schemeclass = 'DD'
      ORDER BY nav_wkend_dt
      )a
    )b;
 
