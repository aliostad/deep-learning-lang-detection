
-- ccm_importstrategy
Create table if not exists	ccm_importstrategy(
id	bigint	 not null		Comment 'ID',
rowstamp	bigint	 not null		Comment '时间戳',
fileprocessor	varchar(40)	 not null		Comment '文件处理器',
usefor	varchar(20)	 not null		Comment '用途',
enabled	tinyint	 not null	 default '0'	Comment '当前是否可用',
paramjson	text			Comment '处理器参数json配置',
name	varchar(50)	 not null		Comment '策略名称',
remark	varchar(200)			Comment '备注',
		primary key(id))	COMMENT '文件导入策略';

-- 模块
insert into ccm_module(ID ,moduleno,parentno,name,enabled,remark,sort,level,defselected)
Values
(wbc_central.GetSequenceByID('010'),'water.basesys.fileimpexp','water.basesys','导入导出策略','1',null,'2101','3','1'),
(wbc_central.GetSequenceByID('010'),'water.basesys.fileimpexp.importstrategy','water.basesys.fileimpexp','导入策略定义','1',null,'2102','4','1');


call p_bs_tablechangestamp('ccm_module',0,unix_timestamp(now())*1000);
update ccm_module set remark = LPAD(id,12,0);

-- 可分配权限

insert into ccm_permission(ID ,moduleno,permission,name,deppageperms,depapiperms,remark)
Values
(wbc_central.GetSequenceByID('011'),'water.basesys.fileimpexp.importstrategy','query','查询','#query,#read',null,null),
(wbc_central.GetSequenceByID('011'),'water.basesys.fileimpexp.importstrategy','create','新增','#create,#duplicate',null,null),
(wbc_central.GetSequenceByID('011'),'water.basesys.fileimpexp.importstrategy','edit','编辑','#edit',null,null),
(wbc_central.GetSequenceByID('011'),'water.basesys.fileimpexp.importstrategy','delete','删除','#delete',null,null),
(wbc_central.GetSequenceByID('011'),'water.basesys.fileimpexp.importstrategy','fromcentral','从中心下载','#fromcentral',null,null),
(wbc_central.GetSequenceByID('011'),'water.mread.read.import','query','查询','#query',null,null),
(wbc_central.GetSequenceByID('011'),'water.mread.read.import','import','导入','#import',null,null);


call p_bs_tablechangestamp('ccm_permission',0,unix_timestamp(now())*1000);

-- 页面权限
insert into ccm_pagepermission(ID ,moduleno,permission,name,deppageperms,depapiperms,remark)
Values
(wbc_central.GetSequenceByID('012'),'water.basesys.fileimpexp.importstrategy','query','查询',null,'#query',null),
(wbc_central.GetSequenceByID('012'),'water.basesys.fileimpexp.importstrategy','read','读取',null,'#read',null),
(wbc_central.GetSequenceByID('012'),'water.basesys.fileimpexp.importstrategy','create','新增','#read','#create,#insert',null),
(wbc_central.GetSequenceByID('012'),'water.basesys.fileimpexp.importstrategy','duplicate','复制','#read','#duplicate,#insert',null),
(wbc_central.GetSequenceByID('012'),'water.basesys.fileimpexp.importstrategy','edit','编辑','#read','#edit,#update',null),
(wbc_central.GetSequenceByID('012'),'water.basesys.fileimpexp.importstrategy','delete','删除','#read','#delete',null),
(wbc_central.GetSequenceByID('012'),'water.basesys.fileimpexp.importstrategy','fromcentral','从中心下载',null,'#queryforlist,#otheract.fromcentral',null),
(wbc_central.GetSequenceByID('012'),'water.mread.read.import','query','查询',null,'#query,water.mread.read.importbatch#query',null),
(wbc_central.GetSequenceByID('012'),'water.mread.read.import','import','导入',null,'#batch.import,water.webmain.fileupload.fileupload#upload',null);

call p_bs_tablechangestamp('ccm_pagepermission',0,unix_timestamp(now())*1000);