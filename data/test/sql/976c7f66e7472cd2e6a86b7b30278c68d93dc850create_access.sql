set lines 2048
set head off
set feedback off
spoo tpj_acc.sql
select 'grant select on ' || object_name || ' to TPJ_CMS_CATCH_READ ' ||
                                            ', TPJ_CMS_CATCH_WRITE ' ||
                                            ', TPJ_CMS_DELIVERIES_READ ' ||
                                            ', TPJ_CMS_DELIVERIES_WRITE ' ||
                                            ', TPJ_CMS_MAINTENANCE_READ ' ||
                                            ', TPJ_CMS_MAINTENANCE_WRITE ' ||
                                            ', TPJ_CMS_SUPER_USER ' ||
                                            ', TPJ_INV_CANVASS_READ ' ||
                                            ', TPJ_INV_CANVASS_WRITE ' ||
                                            ', TPJ_INV_ISSUANCE_READ ' ||
                                            ', TPJ_INV_ISSUANCE_WRITE ' ||
                                            ', TPJ_INV_JOB_ORDER_READ ' ||
                                            ', TPJ_INV_JOB_ORDER_WRITE ' ||
                                            ', TPJ_INV_MAINTENACE_READ ' ||
                                            ', TPJ_INV_MAINTENACE_WRITE ' ||
                                            ', TPJ_INV_PURCHASING_READ ' ||
                                            ', TPJ_INV_PURCHASING_WRITE ' ||
                                            ', TPJ_INV_QUOTATION_READ ' ||
                                            ', TPJ_INV_QUOTATION_WRITE ' ||
                                            ', TPJ_INV_RECEIVING_READ ' ||
                                            ', TPJ_INV_RECEIVING_WRITE ' ||
                                            ', TPJ_INV_REQUESITION_READ ' ||
                                            ', TPJ_INV_REQUESITION_WRITE ' ||
                                            ', TPJ_INV_SUPER_USER ' ||
                                            ', TPJ_PMS_APPLICANT_READ ' ||
                                            ', TPJ_PMS_APPLICANT_WRITE ' ||
                                            ', TPJ_PMS_EMPLOYEES_READ ' ||
                                            ', TPJ_PMS_EMPLOYEES_WRITE ' ||
                                            ', TPJ_PMS_LEAVES_READ ' ||
                                            ', TPJ_PMS_LEAVES_WRITE ' ||
                                            ', TPJ_PMS_MAINTENANCE_READ ' ||
                                            ', TPJ_PMS_MAINTENANCE_WRITE ' ||
                                            ', TPJ_PMS_SUPER_USER ' ||
                                            ', TPJ_PMS_VOYAGES_READ ' ||
                                            ', TPJ_PMS_VOYAGES_WRITE ' ||
                                            ', TPJ_PYS_ATTENDANCE_READ ' ||
                                            ', TPJ_PYS_ATTENDANCE_WRITE ' ||
                                            ', TPJ_PYS_INCENTIVE_READ ' ||
                                            ', TPJ_PYS_INCENTIVE_WRITE ' ||
                                            ', TPJ_PYS_MAINTENANCE_READ ' ||
                                            ', TPJ_PYS_MAINTENANCE_WRITE ' ||
                                            ', TPJ_PYS_PAYROLL_READ ' ||
                                            ', TPJ_PYS_PAYROLL_WRITE ' ||
                                            ', TPJ_PYS_SUPER_USER ' ||
                                            ', TPJ_PYS_TRANSACTION_READ ' ||
                                            ', TPJ_PYS_TRANSACTION_WRITE; '
from user_objects 
where object_type in ('TABLE', 'VIEW', 'SEQUENCE');

select 'grant execute on ' || object_name ||  ' to TPJ_CMS_CATCH_READ ' ||
                                            ', TPJ_CMS_CATCH_WRITE ' ||
                                            ', TPJ_CMS_DELIVERIES_READ ' ||
                                            ', TPJ_CMS_DELIVERIES_WRITE ' ||
                                            ', TPJ_CMS_MAINTENANCE_READ ' ||
                                            ', TPJ_CMS_MAINTENANCE_WRITE ' ||
                                            ', TPJ_CMS_SUPER_USER ' ||
                                            ', TPJ_INV_CANVASS_READ ' ||
                                            ', TPJ_INV_CANVASS_WRITE ' ||
                                            ', TPJ_INV_ISSUANCE_READ ' ||
                                            ', TPJ_INV_ISSUANCE_WRITE ' ||
                                            ', TPJ_INV_JOB_ORDER_READ ' ||
                                            ', TPJ_INV_JOB_ORDER_WRITE ' ||
                                            ', TPJ_INV_MAINTENACE_READ ' ||
                                            ', TPJ_INV_MAINTENACE_WRITE ' ||
                                            ', TPJ_INV_PURCHASING_READ ' ||
                                            ', TPJ_INV_PURCHASING_WRITE ' ||
                                            ', TPJ_INV_QUOTATION_READ ' ||
                                            ', TPJ_INV_QUOTATION_WRITE ' ||
                                            ', TPJ_INV_RECEIVING_READ ' ||
                                            ', TPJ_INV_RECEIVING_WRITE ' ||
                                            ', TPJ_INV_REQUESITION_READ ' ||
                                            ', TPJ_INV_REQUESITION_WRITE ' ||
                                            ', TPJ_INV_SUPER_USER ' ||
                                            ', TPJ_PMS_APPLICANT_READ ' ||
                                            ', TPJ_PMS_APPLICANT_WRITE ' ||
                                            ', TPJ_PMS_EMPLOYEES_READ ' ||
                                            ', TPJ_PMS_EMPLOYEES_WRITE ' ||
                                            ', TPJ_PMS_LEAVES_READ ' ||
                                            ', TPJ_PMS_LEAVES_WRITE ' ||
                                            ', TPJ_PMS_MAINTENANCE_READ ' ||
                                            ', TPJ_PMS_MAINTENANCE_WRITE ' ||
                                            ', TPJ_PMS_SUPER_USER ' ||
                                            ', TPJ_PMS_VOYAGES_READ ' ||
                                            ', TPJ_PMS_VOYAGES_WRITE ' ||
                                            ', TPJ_PYS_ATTENDANCE_READ ' ||
                                            ', TPJ_PYS_ATTENDANCE_WRITE ' ||
                                            ', TPJ_PYS_INCENTIVE_READ ' ||
                                            ', TPJ_PYS_INCENTIVE_WRITE ' ||
                                            ', TPJ_PYS_MAINTENANCE_READ ' ||
                                            ', TPJ_PYS_MAINTENANCE_WRITE ' ||
                                            ', TPJ_PYS_PAYROLL_READ ' ||
                                            ', TPJ_PYS_PAYROLL_WRITE ' ||
                                            ', TPJ_PYS_SUPER_USER ' ||
                                            ', TPJ_PYS_TRANSACTION_READ ' ||
                                            ', TPJ_PYS_TRANSACTION_WRITE; '
from user_objects 
where object_type in ('FUNCTION', 'PROCEDURE');

spoo off


set lines 256
set feedback off
set head off
spoo tpj_syn.sql

select 'drop public synonym ' || object_name || ';'
from user_objects 
where object_type in ('TABLE','FUNCTION', 'PROCEDURE', 'VIEW', 'SEQUENCE');

select 'create or replace public synonym ' || object_name || ' for ' || object_name || ';'
from user_objects 
where object_type in ('TABLE','FUNCTION', 'PROCEDURE', 'VIEW', 'SEQUENCE');

spoo off


