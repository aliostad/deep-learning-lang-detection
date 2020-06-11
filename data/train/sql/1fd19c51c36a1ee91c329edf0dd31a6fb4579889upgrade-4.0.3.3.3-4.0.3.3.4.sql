-- upgrade-4.0.3.3.3-4.0.3.3.4.sql

SELECT acs_log__debug('/packages/intranet-timesheet2/sql/postgresql/upgrade/upgrade-4.0.3.3.3-4.0.3.3.4.sql','');
		
SELECT im_new_menu(
        'intranet-timesheet2',
        'timesheet2_absences_export_vacation',
        'Export Vacation Data',
        '/intranet-dw-light/vacation.csv',
        900,
        'timesheet2_absences',
        null
);

SELECT im_new_menu_perms('timesheet2_absences_export_vacation', 'P/O Admins');
SELECT im_new_menu_perms('timesheet2_absences_export_vacation', 'HR Managers');


SELECT im_new_menu(
        'intranet-timesheet2',
        'timesheet2_absences_import_vacation',
        'Import Vacation Data',
        '/intranet-hr/upload-vacationdata.tcl',
        910,
        'timesheet2_absences',
        null
);

SELECT im_new_menu_perms('timesheet2_absences_import_vacation', 'P/O Admins');
SELECT im_new_menu_perms('timesheet2_absences_import_vacation', 'HR Managers');
