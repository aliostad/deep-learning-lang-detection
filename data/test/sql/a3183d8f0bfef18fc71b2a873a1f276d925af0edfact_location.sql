-- **********************************************************
-- $Id: fact_location.sql,v 1.15 2014/02/21 14:30:35 skempins Exp $
-- CREATE FACT TABLE FOR LOCATIONS
-- THIS FACTLESS FACT TABLE JOINS PERMIT, PROJECT, COUNTY,
-- AND SITE INFORMATION TOGETHER.  THIS ENABLES THE USER TO
-- BROWSE GEOGRAPHICALLY
--
-- **********************************************************
EXECUTE build_util.drop_table('NEW_FACT_LOCATION');
CREATE TABLE NEW_FACT_LOCATION
   (COUNTY_KEY         NUMBER(11),
    SITE_KEY           NUMBER(11),
    PERMIT_KEY         NUMBER(11),
    PROJECT_KEY        NUMBER(11),
    STATION_KEY        NUMBER(11))
TABLESPACE &TABLE_TABLESPACE
   PCTFREE 0 PCTUSED 99
   PARALLEL NOLOGGING
	 &COMPRESS_OPTION
/

INSERT /*+APPEND*/ INTO NEW_FACT_LOCATION                --only 1 permit_key for type ERP inserted into location table
SELECT DISTINCT NVL(COUNTY_KEY, 1),                        --find erroneous condition
          NVL(SITE_KEY, 1),                          --if ERP has no stationID then it will not insert into location 
          NVL(PERMIT_KEY, 1),
          NVL(PROJECT_KEY, 1),
          NVL(STATION_KEY, 1)
     FROM new_dim_county DIM_COUNTY,
          new_dim_site DIM_SITE,
          new_dim_permit DIM_PERMIT,
          proj_site_str,
          PROJ_SITE,
          PROJ_STN,
          new_dim_project DIM_PROJECT,
          new_dim_station DIM_STATION
    WHERE DIM_COUNTY.CNTY_ID = proj_site_str.cnty_id
      AND DIM_SITE.SITE_ID = proj_site_str.site_id
      AND DIM_PERMIT.CUR_PRMT_ID = proj_stn.cur_id
      AND DIM_SITE.SITE_ID = proj_stn.site_id
      AND DIM_PROJECT.PRMT_PROJ_ID = proj_site.cur_id 
      AND DIM_SITE.SITE_ID = PROJ_SITE.site_id --count of prmt_proj_stn is 49114 IDs
      AND DIM_STATION.STN_ID = PROJ_STN.stn_id(+)                         --count of prmt_proj_site is 61642 IDs
/
COMMIT;

-- ADD FOREIGN KEY INDEXES
EXECUTE build_util.create_index('NEW_FACT_LOCATION','county_key','&INDEX_TABLESPACE');
EXECUTE build_util.create_index('NEW_FACT_LOCATION','site_key','&INDEX_TABLESPACE');
EXECUTE build_util.create_index('NEW_FACT_LOCATION','permit_key','&INDEX_TABLESPACE');
EXECUTE build_util.create_index('NEW_FACT_LOCATION','project_key','&INDEX_TABLESPACE');
EXECUTE build_util.create_index('NEW_FACT_LOCATION','station_key','&INDEX_TABLESPACE');

EXECUTE dbms_stats.gather_table_stats(USER,'NEW_FACT_LOCATION');

-- **************************************************************
-- CREATE FACT_LOCATION_TEMP TABLE
-- THIS LOCATION TABLE IS USED FOR PERMITS WITHOUT STATIONS:  ERP
-- TABLE IS USED TO LINK PROJECT OR SITE WITH PERMIT
-- **************************************************************
EXECUTE build_util.drop_table('NEW_FACT_LOCATION_TEMP');
CREATE TABLE NEW_FACT_LOCATION_TEMP
    (COUNTY_KEY         NUMBER(11),
     SITE_KEY           NUMBER(11),
     PERMIT_KEY         NUMBER(11),
     PROJECT_KEY        NUMBER(11))
 TABLESPACE &TABLE_TABLESPACE
   PCTFREE 0 PCTUSED 99
   PARALLEL NOLOGGING
	 &COMPRESS_OPTION
/
INSERT /*+APPEND*/ 
INTO NEW_FACT_LOCATION_TEMP
   SELECT NVL(COUNTY_KEY, 1),
          NVL(SITE_KEY, 1),
          NVL(PERMIT_KEY, 1),
          NVL(PROJECT_KEY, 1)
   FROM new_dim_county DIM_COUNTY,
          new_dim_site DIM_SITE,
          new_dim_permit DIM_PERMIT,
          proj_site_str,
          PROJ_SITE,
          new_dim_project DIM_PROJECT
   WHERE DIM_COUNTY.CNTY_ID = proj_site_str.cnty_id
      AND DIM_SITE.SITE_ID = proj_site_str.site_id
      AND DIM_PERMIT.CUR_PRMT_ID = proj_site.cur_id
      AND DIM_SITE.SITE_ID = proj_site.site_id
      AND DIM_PROJECT.PRMT_PROJ_ID = proj_site.cur_id
/
COMMIT;

-- ADD FOREIGN KEY INDEXES
EXECUTE build_util.create_index('NEW_FACT_LOCATION_TEMP','county_key','&INDEX_TABLESPACE');
EXECUTE build_util.create_index('NEW_FACT_LOCATION_TEMP','site_key','&INDEX_TABLESPACE');
EXECUTE build_util.create_index('NEW_FACT_LOCATION_TEMP','permit_key','&INDEX_TABLESPACE');
EXECUTE build_util.create_index('NEW_FACT_LOCATION_TEMP','project_key','&INDEX_TABLESPACE');

EXECUTE dbms_stats.gather_table_stats(USER,'NEW_FACT_LOCATION_TEMP');
