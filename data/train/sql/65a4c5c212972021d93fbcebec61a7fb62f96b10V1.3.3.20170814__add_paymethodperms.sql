
insert into ccm_permission(ID ,moduleno,permission,name,deppageperms,depapiperms,remark)
Values
(wbc_central.GetSequenceByID('011'),'water.charge.base.paymethod','query','查询','#query,#read',null,null),
(wbc_central.GetSequenceByID('011'),'water.charge.base.paymethod','create','新增','#create,#duplicate',null,null),
(wbc_central.GetSequenceByID('011'),'water.charge.base.paymethod','edit','编辑','#edit',null,null),
(wbc_central.GetSequenceByID('011'),'water.charge.base.paymethod','delete','删除','#delete',null,null),
(wbc_central.GetSequenceByID('011'),'water.charge.base.paymethod','enable','启用','#enable',null,null);

call p_bs_tablechangestamp('ccm_permission',0,unix_timestamp(now())*1000);

--
insert into ccm_pagepermission(ID ,moduleno,permission,name,deppageperms,depapiperms,remark)
Values
(wbc_central.GetSequenceByID('012'),'water.charge.base.paymethod','query','查询',null,'#query',null),
(wbc_central.GetSequenceByID('012'),'water.charge.base.paymethod','read','读取',null,'#read',null),
(wbc_central.GetSequenceByID('012'),'water.charge.base.paymethod','create','新增','#read','#create,#insert,#queryforlist',null),
(wbc_central.GetSequenceByID('012'),'water.charge.base.paymethod','duplicate','复制','#read','#duplicate,#insert',null),
(wbc_central.GetSequenceByID('012'),'water.charge.base.paymethod','edit','编辑','#read','#edit,#update,#batch.saveorder',null),
(wbc_central.GetSequenceByID('012'),'water.charge.base.paymethod','enable','启用','#read','#enable',null),
(wbc_central.GetSequenceByID('012'),'water.charge.base.paymethod','delete','删除','#read','#delete',null);

call p_bs_tablechangestamp('ccm_pagepermission',0,unix_timestamp(now())*1000);

