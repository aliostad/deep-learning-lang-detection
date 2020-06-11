--Create Directory with path to External References files storage
/*==============================================================*/
/* Directories: ext_references                                  */
/*==============================================================*/
CREATE OR REPLACE DIRECTORY ext_data
AS
  '/mnt/ext_references/';

GRANT READ ON DIRECTORY ext_data TO u_dw_source;
GRANT WRITE ON DIRECTORY ext_data TO u_dw_source;
GRANT READ ON DIRECTORY ext_data TO u_dw_cls_stage;
GRANT WRITE ON DIRECTORY ext_data TO u_dw_cls_stage;