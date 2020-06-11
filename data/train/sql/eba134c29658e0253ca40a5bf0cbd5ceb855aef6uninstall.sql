-- author: marcus.gnass@4fb.de
-- description: uninstall script for PlugInFormAssistant (PIFA)

-- drop internal CONTENIDO data for plugin
DELETE FROM con_area WHERE idarea = 100001;
DELETE FROM con_area WHERE idarea = 100002;

DELETE FROM con_nav_main WHERE idnavm = 100001;
DELETE FROM con_nav_sub WHERE idarea = 100001;

DELETE FROM con_files WHERE idarea = 100001;
DELETE FROM con_files WHERE idarea = 100002;

DELETE FROM con_frame_files WHERE idarea = 100001;
DELETE FROM con_frame_files WHERE idarea = 100002;

DELETE FROM con_actions WHERE idarea = 100001;
DELETE FROM con_actions WHERE idarea = 100002;

-- drop table for meta data of PIFA forms
DROP TABLE con_pifa_form;

-- drop table for meta data of PIFA fields
DROP TABLE con_pifa_field;

-- TODO drop user created tables to store form data
