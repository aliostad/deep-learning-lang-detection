insert into SYS_Menu values('Url_MesScanControlPoint_View','过点信息','Url_FMS_Info',300,'设施管理-信息-过点信息','~/MesScanControlPoint/Index','~/Content/Images/Nav/Default.png',1)
insert into ACC_Permission (Code,Desc1,category,Sequence) values('Url_MesScanControlPoint_View','过点信息查看','FMS',19000)


insert into SYS_Menu values('Url_FacilityParamater_View','设备参数','Url_FMS_Info',400,'设施管理-信息-设备参数','~/FacilityParamater/Index','~/Content/Images/Nav/Default.png',1)
insert into ACC_Permission (Code,Desc1,category,Sequence) values('Url_FacilityParamater_View','过点信息查看','FMS',20000)


insert into sys_codemstr values('FacilityParamaterType','设备参数类型',0);
insert into SYS_CodeDet(Code,Value,Desc1,IsDefault,Seq) values('FacilityParamaterType',0,'过点信息',1,1);
insert into SYS_CodeDet(Code,Value,Desc1,IsDefault,Seq)  values('FacilityParamaterType',1,'设备参数',0,2);


insert into sys_codemstr values('FacilityOrderType','设备保养单类型',0);
insert into SYS_CodeDet(Code,Value,Desc1,IsDefault,Seq) values('FacilityOrderType',0,'保养',1,1);
insert into SYS_CodeDet(Code,Value,Desc1,IsDefault,Seq)  values('FacilityOrderType',1,'维修',0,2);
insert into SYS_CodeDet(Code,Value,Desc1,IsDefault,Seq)  values('FacilityOrderType',2,'检测',0,3);


insert into SYS_Menu values('Url_FacilityOrder_View','设备保养单','Url_FMS_Trans',300,'设施管理-事务-设备保养单','~/FacilityOrder/Index','~/Content/Images/Nav/Default.png',1)
insert into ACC_Permission (Code,Desc1,category,Sequence) values('Url_FacilityOrder_View','保养单查看','FMS',21000)
insert into ACC_Permission (Code,Desc1,category,Sequence) values('Url_FacilityOrder_Edit','保养单编辑','FMS',22000)
