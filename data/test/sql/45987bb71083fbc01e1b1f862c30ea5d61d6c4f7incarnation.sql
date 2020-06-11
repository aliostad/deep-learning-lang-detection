--
-- Thorsten Bruhns (Thorsten.Bruhns@opitz-consulting.de)
-- $Id: incarnation.sql 221 2010-11-01 21:33:50Z tbr $
--
-- display known database incarnations
--
column inc format 99
column pinc format 99
column flash_ok format a8
column STATUS format a7
column reset_change format 99999999999
column reset_id format 99999999999
select INCARNATION# inc
      ,PRIOR_INCARNATION# pinc
      ,RESETLOGS_CHANGE# reset_change#
      ,to_char(RESETLOGS_TIME,'dd.mm.yy HH24:mi:ss') rtime
      ,STATUS
      ,to_char(prior_RESETLOGS_TIME,'dd.mm.yy HH24:mi:ss') prtime
      ,RESETLOGS_ID reset_id
      ,FLASHBACK_DATABASE_ALLOWED flash_ok
  from V$DATABASE_INCARNATION
;
