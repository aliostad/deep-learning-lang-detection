/*==============================================================*/
/* Modify Table: nW_DM_MODEL                                    */
/*==============================================================*/
alter table nW_DM_MODEL 
      add OPERATING_SYSTEM     VARCHAR2(255);
      
alter table nW_DM_MODEL 
      add ANNOUNCED_DATE       DATE;
      
alter table nW_DM_MODEL 
      add ICON                 BLOB;

/*==============================================================*/
/* Modify Table: nW_DM_MODEL_CHARACTER                          */
/*==============================================================*/
alter table nW_DM_MODEL_CHARACTER 
      add MODEL_ID             NUMBER(20);

/*==============================================================*/
/* Convert Data                                                 */
/*==============================================================*/
update   nW_DM_MODEL_CHARACTER    
  set   MODEL_ID=(select nW_DM_MODEL_SPEC.MODEL_ID  
  from   nW_DM_MODEL_SPEC
  where   nW_DM_MODEL_SPEC.MODEL_SPEC_ID=nW_DM_MODEL_CHARACTER.MODEL_SPEC_ID);
  
update   nW_DM_MODEL    
  set   OPERATING_SYSTEM=(select nW_DM_MODEL_SPEC.OPERATING_SYSTEM  
  from   nW_DM_MODEL_SPEC
  where  nW_DM_MODEL_SPEC.MODEL_ID=nW_DM_MODEL.MODEL_ID);

update   nW_DM_MODEL    
  set    ANNOUNCED_DATE=(select nW_DM_MODEL_SPEC.ANNOUNCED_DATE  
  from   nW_DM_MODEL_SPEC
  where  nW_DM_MODEL_SPEC.MODEL_ID=nW_DM_MODEL.MODEL_ID);

update   nW_DM_MODEL    
  set    ICON=(select nW_DM_MODEL_SPEC.ICON  
  from   nW_DM_MODEL_SPEC
  where  nW_DM_MODEL_SPEC.MODEL_ID=nW_DM_MODEL.MODEL_ID);

/*==============================================================*/
/* Index: IDX_FK_MOD_CHARACTER                                  */
/*==============================================================*/
create index IDX_FK_MOD_CHARACTER on nW_DM_MODEL_CHARACTER (
   MODEL_ID ASC
);

/*==============================================================*/
/* Index: IDX_MODEL_CHARA_CATEG                                 */
/*==============================================================*/
create index IDX_MODEL_CHARA_CATEG on nW_DM_MODEL_CHARACTER (
   CATEGORY ASC
);

/*==============================================================*/
/* Index: IDX_MODEL_CHARA_NAME                                  */
/*==============================================================*/
create index IDX_MODEL_CHARA_NAME on nW_DM_MODEL_CHARACTER (
   NAME ASC
);

/*==============================================================*/
/* Index: IDX_MODEL_CHARA_VAL                                   */
/*==============================================================*/
create index IDX_MODEL_CHARA_VAL on nW_DM_MODEL_CHARACTER (
   VALUE ASC
);

/*==============================================================*/
/* Modify Table: nW_DM_MODEL_CHARACTER                          */
/*==============================================================*/
alter table nW_DM_MODEL_CHARACTER
   add constraint FK_MODEL_CHARACTER foreign key (MODEL_ID)
      references nW_DM_MODEL (MODEL_ID)
      on delete cascade;


/*==============================================================*/
/* Drop Table: nW_DM_MODEL_SPEC                                 */
/*==============================================================*/
drop table nW_DM_MODEL_SPEC cascade constraints;

/*==============================================================*/
/* Modify Table: nW_DM_MODEL_CHARACTER                          */
/*==============================================================*/
alter table nW_DM_MODEL_CHARACTER
   drop column MODEL_SPEC_ID;

/*==============================================================*/
/* Commit                                                       */
/*==============================================================*/
commit;