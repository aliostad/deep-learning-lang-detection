-- ******************************************************
-- $Id: dim_legacy.sql,v 1.8 2014/02/12 14:40:41 skempins Exp $
-- Creates the legacy permit numbers.
-- ******************************************************

EXECUTE build_util.drop_table('NEW_DIM_LEGACY');

CREATE TABLE NEW_DIM_LEGACY
(	PERMIT_KEY                 NUMBER(10),
	APP_NUM			   VARCHAR2(35)
)
TABLESPACE &TABLE_TABLESPACE
   PCTFREE 0 PCTUSED 99
   PARALLEL NOLOGGING
;

INSERT INTO NEW_DIM_LEGACY
(	PERMIT_KEY
	, APP_NUM
)
SELECT permit_key
  , lgcy_app_no app_num
FROM new_dim_permit dim_permit 
WHERE lgcy_app_no IS NOT NULL
;
COMMIT;

EXECUTE build_util.create_index('NEW_DIM_LEGACY','permit_key','&INDEX_TABLESPACE');
EXECUTE dbms_stats.gather_table_stats(USER,'NEW_DIM_LEGACY');
