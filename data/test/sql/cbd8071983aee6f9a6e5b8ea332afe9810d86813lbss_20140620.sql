/*update the column action_type of table bss_panel_nav_define*/
alter table bss_panel_nav_define alter column action_type varchar(20);

/*add the column epg_rel_id for the table bss_panel_panel_item_map*/

 alter table bss_panel_panel_item_map add epg_rel_id bigint(19);

/*update the column epg_nav_id of table bss_panel_package_panel_map*/
alter table bss_panel_package_panel_map alter column epg_nav_id varchar(256);


/*update the data of table system_config*/

UPDATE system_config SET configvalue = 'http://192.168.2.106:8080/tsop-api/api/getPreviewTemplate.json' WHERE configkey = 'sysPreviewTemplateUrl';
UPDATE system_config SET configvalue = 'http://192.168.2.106:8080/tsop-api/api/getPreviewItem.json' WHERE configkey = 'sysPreviewItemUrl';
UPDATE system_config SET configvalue = 'http://192.168.2.106:8080/tsop-api/api/getPreviewItemData.json' WHERE configkey = 'sysPreviewItemDataUrl';
UPDATE system_config SET configvalue = 'http://192.168.2.106:8080/tsop-api/api/getPanel.json' WHERE configkey = 'sysPanelUrl';
UPDATE system_config SET configvalue = 'http://192.168.2.106:8080/tsop-api/api/getPanelPackage.json' WHERE configkey = 'sysPanelPackageUrl';
UPDATE system_config SET configvalue = 'http://192.168.2.106:8080/tsop-api/api/getPanelItem.json' WHERE configkey = 'sysPanelItemUrl';
UPDATE system_config SET configvalue = 'http://192.168.2.106:8080/tsop-api/api/getPanelItemRel.json' WHERE configkey = 'sysPanelItemMapUrl';
UPDATE system_config SET configvalue = 'http://192.168.2.106:8080/tsop-api/api/getNavDefine.json' WHERE configkey = 'sysNavUrl';
UPDATE system_config SET configvalue = 'http://192.168.2.106:8080/tsop-api/api/getPanelPackageRel.json' WHERE configkey = 'sysPanelPackageMapUrl';


