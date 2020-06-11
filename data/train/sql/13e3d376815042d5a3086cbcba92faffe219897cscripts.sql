select model.id, model.urldocument FROM "поручениеобработкиотчетности" as model 
	            inner join reportpackage report on
		            model.reportpackageid = report.id 
	            inner join информацияопакете info on
		            model.packageinfoid = info.id
	            where
		            model.актуальныйСтатус = 'IncomingNumberAssotiated' and
		            info.rootname like 'ПакетСООУРЦБ1408%' and
		            info.modelname = 'PURCB' 
		            and
		            info.reportyear = '2012' and 
		            info.quarter = '3';

select model.id, model.urldocument, info.reportmonth, info.reportday, report.creationDate FROM "поручениеобработкиотчетности" as model 
	            inner join reportpackage report on
		            model.reportpackageid = report.id 
	            inner join информацияопакете info on
		            model.packageinfoid = info.id
	            where
		            model.актуальныйСтатус = 'IncomingNumberAssotiated' and
		            info.rootname like 'ПакетСООУРЦБ1409%' and
		            info.modelname = 'PURCB' 
		            and
		            info.reportmonth = '12' and
		            info.reportyear = '2012';