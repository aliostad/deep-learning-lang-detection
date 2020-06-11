# after the import is successfully done, add constraints to the dl_deals_lender_programs table.
spool constraints_lender_programs.log

alter table dl_deals_lender_programs add constraint pk_lender_programs primary key (dealid)
USING INDEX PCTFREE 10 INITRANS 10 MAXTRANS 255 COMPUTE STATISTICS NOLOGGING
  STORAGE(INITIAL 1056768 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBINDX"  ENABLE;

alter table dl_deals_lender_programs add constraint fk_lender_programs foreign key(dealid) references dl_deals(dealid) on delete cascade;

spool off;
