/*==============================================================*/
/* Table: nW_DM_SOFTWARE_EVALUATE                             */
/*==============================================================*/
create table nW_DM_SOFTWARE_EVALUATE  (
   EVALUATE_ID          NUMBER(20)                      not null,
   SOFTWARE_ID          NUMBER(20)                      not null,
   REMARK               CLOB,
   GRADE                NUMBER(2)                       not null,
   USER_NAME            VARCHAR(20),
   USER_IP              VARCHAR(30),
   CREATED_TIME         DATE                            not null,
   constraint PK_NW_DM_SOFTWARE_EVALUATE primary key (EVALUATE_ID)
);

/*==============================================================*/
/* Index: IDX_FK_EVAL_TO_SOFT                                   */
/*==============================================================*/
create index IDX_FK_EVAL_TO_SOFT on nW_DM_SOFTWARE_EVALUATE (
   SOFTWARE_ID ASC
);

/*==============================================================*/
/* Index: IDX_SOFT_EVAL_USERID                                  */
/*==============================================================*/
create index IDX_SOFT_EVAL_USERID on nW_DM_SOFTWARE_EVALUATE (
   USER_NAME ASC
);

/*==============================================================*/
/* Index: IDX_SOFT_EVAL_CRET_TIME                               */
/*==============================================================*/
create index IDX_SOFT_EVAL_CRET_TIME on nW_DM_SOFTWARE_EVALUATE (
   CREATED_TIME ASC
);

alter table nW_DM_SOFTWARE_EVALUATE
   add constraint FK_SOFT_EVAL foreign key (SOFTWARE_ID)
      references nW_DM_SOFTWARE (SOFTWARE_ID)
      on delete cascade;


/*==============================================================*/
/* Table: MODEL_CLASSIFICATION                                  */
/*==============================================================*/
create table MODEL_CLASSIFICATION  (
   MODEL_CLASSIFICATION_ID NUMBER(20)                      not null,
   EXTERNAL_ID          VARCHAR(255)                    not null,
   NAME                 VARCHAR(255)                    not null,
   DESCRIPTION          VARCHAR2(1024),
   MODEL_SELECTOR       BLOB,
   constraint PK_MODEL_CLASSIFICATION primary key (MODEL_CLASSIFICATION_ID),
   constraint AK_KEY_EXT_ID_MODEL_C_MODEL_CL unique (EXTERNAL_ID)
);

/*==============================================================*/
/* Index: IDX_MODEL_CLASS_NAME                                  */
/*==============================================================*/
create index IDX_MODEL_CLASS_NAME on MODEL_CLASSIFICATION (
   NAME ASC
);

/*==============================================================*/
/* Table: PREDEFINED_MODEL_SELECTOR                             */
/*==============================================================*/
create table PREDEFINED_MODEL_SELECTOR  (
   ID                   NUMBER(20)                      not null,
   MODEL_ID             NUMBER(20),
   MODEL_CLASSIFICATION_ID NUMBER(20),
   constraint PK_PREDEFINED_MODEL_SELECTOR primary key (ID)
);

/*==============================================================*/
/* Index: IDX_PRED_MOD_SLTOR_FK1                                */
/*==============================================================*/
create index IDX_PRED_MOD_SLTOR_FK1 on PREDEFINED_MODEL_SELECTOR (
   MODEL_CLASSIFICATION_ID ASC
);

/*==============================================================*/
/* Index: IDX_PRED_MOD_SLTOR_FK2                                */
/*==============================================================*/
create index IDX_PRED_MOD_SLTOR_FK2 on PREDEFINED_MODEL_SELECTOR (
   MODEL_ID ASC
);


alter table PREDEFINED_MODEL_SELECTOR
   add constraint FK_PRED_MODE_SELTOR foreign key (MODEL_CLASSIFICATION_ID)
      references MODEL_CLASSIFICATION (MODEL_CLASSIFICATION_ID)
      on delete cascade;

alter table PREDEFINED_MODEL_SELECTOR
   add constraint FK_PRE_MS_SELECTED_MODELS foreign key (MODEL_ID)
      references nW_DM_MODEL (MODEL_ID)
      on delete cascade;

/*==============================================================*/
/* Table: nW_DM_SOFTWARE_PACKAGE_MODEL                        */
/*==============================================================*/
alter table nW_DM_SOFTWARE_PACKAGE_MODEL
   add MODEL_CLASSIFICATION_ID NUMBER(20);
   
/*==============================================================*/
/* Index: IDX_FK_SOFT_PKG_REF_MOD_CLAS                          */
/*==============================================================*/
create index IDX_FK_SOFT_PKG_REF_MOD_CLAS on nW_DM_SOFTWARE_PACKAGE_MODEL (
   MODEL_CLASSIFICATION_ID ASC
);

alter table nW_DM_SOFTWARE_PACKAGE_MODEL
   add constraint FK_SPKG_REF_MODEL_CLASS foreign key (MODEL_CLASSIFICATION_ID)
      references MODEL_CLASSIFICATION (MODEL_CLASSIFICATION_ID)
      on delete cascade;

/*==============================================================*/
/* Table: nW_DM_SOFTWARE_PACKAGE                              */
/*==============================================================*/
alter table nW_DM_SOFTWARE_PACKAGE
   add NAME                 VARCHAR2(1024);
   
   
/*==============================================================*/
/* Index: IDX_SW_TRK_TRK_TIME_WEEK                              */
/*==============================================================*/
drop index IDX_SW_TRK_TRK_TIME_WEEK;
create index IDX_SW_TRK_TRK_TIME_WEEK on nW_DM_SOFTWARE_TRACKING_LOG (
   to_char(TIME_STAMP, 'YYYY-IW') ASC
);

/*==============================================================*/
/* View: V_SOFTWARE_TRACK_LOG_WEEKLY                            */
/*==============================================================*/
create or replace view V_SOFTWARE_TRACK_LOG_WEEKLY as
select min(TRACKING_LOG_ID) as id, software_id, package_id, tracking_type, to_char(TIME_STAMP, 'YYYY-IW') as week_of_year, count(*) as count from NW_DM_SOFTWARE_TRACKING_LOG
group by software_id, package_id, tracking_type, to_char(TIME_STAMP, 'YYYY-IW')
with read only;


/*==============================================================*/
/* Table: nW_DM_SUBSCRIBER                                    */
/*==============================================================*/
alter table nW_DM_SUBSCRIBER
      add FIRSTNAME            VARCHAR2(32);
 
alter table nW_DM_SUBSCRIBER
      add LASTNAME             VARCHAR2(32);
 
 alter table nW_DM_SUBSCRIBER
      add EMAIL                VARCHAR2(200);
 
 