# -*- coding: utf-8 -*-

__version__ = '0.1'

__all__ = ['core','alarm','geo','logs','param','report','sys','system','zone']

imports = [
	('/api/info.*', 'api.core.Info'),
	('/api/version.*', 'api.core.Version'),
	('/api/debug_jqGrid.*', 'api.core.Debug_jqGrid'),
	('/api/debug_geo.*', 'api.core.DebugGeo'),
	('/api/get_geo.*', 'api.core.GetGeo'),
	('/api/gmap/ceng*', 'api.core.GMapCeng'),
	('/api/misc/drivers*', 'api.core.Sys_Misc_Drivers'),
	('/api/admin/operations*', 'api.core.Admin_Operations'),

	('/api/geo/del.*', 'api.geo.Del'),
	('/api/geo/taskdel.*', 'api.geo.Task_Del'),
	('/api/geo/taskdelall.*', 'api.geo.Task_DelAll'),
	('/api/geo/get*', 'api.geo.Get'),
	('/api/geo/dates*', 'api.geo.Dates'),
	('/api/geo/info*', 'api.geo.Info'),
	('/api/geo/last*', 'api.geo.Last'),
	('/api/geo/count*', 'api.geo.Count'),
	('/api/geo/report*', 'api.geo.Report'),
	('/api/geo/purge*', 'api.geo.Purge'),		# “¤ «ï¥â ®¤­ã â®çªã

	('/api/report/get*', 'api.report.Get'),

	('/api/export/xls*', 'api.export.XLS'),
	('/api/export/list*', 'api.export.List'),
	('/api/export/del*', 'api.export.Del'),
	('/api/export/get/report.xls', 'api.export.Get'),

	('/api/system/add*', 'api.system.Add'),
	('/api/system/del*', 'api.system.Del'),
	('/api/system/desc*', 'api.system.Desc'),
	('/api/system/sort*', 'api.system.Sort'),
	('/api/system/config*', 'api.system.Config'),
	('/api/system/tags*', 'api.system.Tags'),
	('/api/system/car*', 'api.system.Car'),
	('/api/system/secure_list*', 'api.system.SecureList'),
	('/api/system/saveconfig*', 'api.system.SaveConfig'),
	('/api/system/seticon*', 'api.system.SetIcon'),

	('/api/param/desc*', 'api.param.Desc'),

	('/api/logs/get*', 'api.logs.Get'),
	('/api/logs/del*', 'api.logs.Del'),
	('/api/logs/purge*', 'api.logs.Purge'),
	('/api/logs/count*', 'api.logs.Count'),


	('/api/zone/add*', 'api.zone.Add'),
	('/api/zone/get*', 'api.zone.Get'),
	('/api/zone/del*', 'api.zone.Del'),
	('/api/zone/info*', 'api.zone.Info'),
	('/api/zone/rule/create*', 'api.zone.Rule_Create'),
	('/api/zone/rule/get*', 'api.zone.Rule_Get'),
	('/api/zone/rule/del*', 'api.zone.Rule_Del'),

	('/api/alarm/confirm*', 'api.alarm.Confirm'),
	('/api/alarm/cancel*', 'api.alarm.Cancel'),
	('/api/alarm/get*', 'api.alarm.Get'),

	('/api/firmware/list.*', 'api.firmware.List'),
]
