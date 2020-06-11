--------------------------------------------------------
--  File created - Wednesday-May-28-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table HTMP_DIVIDEND_EXT
--------------------------------------------------------

  CREATE TABLE HTMP_DIVIDEND_EXT 
   (	SCHEME VARCHAR2(50 BYTE), 
	VALUE_DATE DATE, 
	SCHEME_CLASS VARCHAR2(50 BYTE), 
	EX_DIVIDEND_NAV NUMBER(21,5), 
	PU_DIVIDEND_NAV NUMBER(21,5), 
	UPLOAD_DT DATE
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY HG_HAMC_PUMP_DIR
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY NEWLINE FIELDS TERMINATED BY ',' MISSING FIELD VALUES ARE NULL REJECT ROWS
WITH ALL NULL FIELDS (SCHEME,VALUE_DATE,SCHEME_CLASS,EX_DIVIDEND_NAV,PU_DIVIDEND_NAV,UPLOAD_DT)     )
      LOCATION
       ( 'DIVIDEND.CSV'
       )
    );


