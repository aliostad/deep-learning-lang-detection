
  CREATE OR REPLACE  VIEW HV_PER_AUM (SCHEME, SCHEME_NAME, NAV_DATE, PREV_DATE, UNITS, PREV_UNITS, AMOUNT, NET_ASSET_AMOUNT, PER_AUM, SOURCING_DD, SOURCING_MM, SOURCING_YY, SCH_NAME) AS 
  SELECT SCHEME,
    SCHEME_NAME,
    NAV_DATE,
    PREV_DATE,
    UNITS,
    prev_units,
    AMOUNT,
    NET_ASSET_AMOUNT,
    (AMOUNT/NET_ASSET_AMOUNT)*100 PER_AUM,
    SOURCING_DD,
    SOURCING_MM,
    SOURCING_YY,
   sch_name
    /*,
    nav_date_format*/
  FROM
    (SELECT SCHNAVBD.SCHEME AS SCHEME,
      SECURITY.NAME SCHEME_NAME,
      SCHNAVBD.NAV_DATE                                                                                                                     AS NAV_DATE,
      (SCHNAVBD.NAV_DATE -1)                                                                                                                AS PREV_DATE,
      SCHNAVBD.UNITS                                                                                                                        AS UNITS,
      LAG( SCHNAVBD.UNITS, 1, 0) OVER (partition BY scheme.scheme_name,SECURITY.NAME,SCHNAVBD.SCHEME ORDER BY SCHNAVBD.NAV_DATE,SECURITY.NAME,SCHNAVBD.SCHEME,scheme.scheme_name) AS prev_units,
      -SCHNAVBD.FCY_AMOUNT                                                                                                                  AS AMOUNT,
      SUM(WEEKNAV.LAST_NET_ASSETS)                                                                                                          AS NET_ASSET_AMOUNT,
      TO_NUMBER( TO_CHAR(SCHNAVBD.NAV_DATE,'DD')) SOURCING_DD,
      TO_NUMBER( TO_CHAR(SCHNAVBD.NAV_DATE,'MM')) SOURCING_MM,
      TO_NUMBER( TO_CHAR(SCHNAVBD.NAV_DATE,'YY')) SOURCING_YY,
      scheme.scheme_name as sch_name
      /*,
      TO_DATE(SCHNAVBD.NAV_DATE,'DD-MM-YYYY') nav_date_format*/
    FROM HI_SCHNAVBD_CURR SCHNAVBD,
      HM_SECURITY SECURITY,
      HI_WEEKNAV_CURR WEEKNAV, 
      HM_SCHEME scheme
    WHERE SCHNAVBD.SECURITY     =SECURITY.SECURITY
    AND SCHNAVBD.SCHEME         = WEEKNAV.SCHEME
    AND SCHNAVBD.NAV_DATE       = WEEKNAV.WEEKEND_DT
    AND SECURITY.RECTYPE        ='L'
    AND SCHNAVBD.ASSET_TYPE     ='01'
    AND WEEKNAV.SCHCLASS NOT   IN ('GLOBAL')
    AND WEEKNAV.LAST_UNITS_OUTS >'0'
    and   SCHNAVBD.SCHEME         =  scheme.scheme
    GROUP BY SCHNAVBD.SCHEME,
      SECURITY.NAME,
      SCHNAVBD.NAV_DATE,
      SCHNAVBD.UNITS,
      -SCHNAVBD.FCY_AMOUNT,
       scheme.scheme_name
    ORDER BY SCHNAVBD.SCHEME,
      -- TO_DATE(SCHNAVBD.NAV_DATE,'DD-MM-YYYY'),
      SCHEME_NAME
    )A
  ORDER BY
    /*nav_date_format,*/
    SCHEME,
    SCHEME_NAME,sch_name;
 
