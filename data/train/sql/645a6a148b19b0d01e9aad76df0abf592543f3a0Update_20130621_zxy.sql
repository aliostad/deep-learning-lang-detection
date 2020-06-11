insert sys_menu(Code,Name,Parent,Seq,Desc1,PageUrl,ImageUrl,IsActive) values
('Url_CabGuideHomeMadeSubView_View','自制驾驶室出库分线视图','Menu.Production.Trans',202,'自制驾驶室出库分线视图','~/CabGuide/HomeMadeSubViewIndex','~/Content/Images/Nav/Default.png',1)
go

insert into acc_permission values('Url_CabGuideHomeMadeSubView_View','自制驾驶室出库分线视图','Production')
go


insert sys_menu(Code,Name,Parent,Seq,Desc1,PageUrl,ImageUrl,IsActive) values
('Url_CabGuideOutSoureSubView_View','外购驾驶室出库分线视图','Menu.Production.Trans',203,'外购驾驶室出库分线视图','~/CabGuide/OutSoureSubViewIndex','~/Content/Images/Nav/Default.png',1)
go

insert into acc_permission values('Url_CabGuideOutSoureSubView_View','外购驾驶室出库分线视图','Production')
go


insert into sys_codemstr values('DateOption','日期选项',0)
go
insert into sys_codedet values('DateOption','EQ','等于',1,1)
insert into sys_codedet values('DateOption','GT','大于',0,2)
insert into sys_codedet values('DateOption','GE','大于等于',0,3)
insert into sys_codedet values('DateOption','LT','小于',0,4)
insert into sys_codedet values('DateOption','LE','小于等于',0,5)
insert into sys_codedet values('DateOption','BT','大于等于且小于等于',0,6)
go


insert sys_menu(Code,Name,Parent,Seq,Desc1,PageUrl,ImageUrl,IsActive) values
('Url_OrderMstr_Production_ConditionImport','非整车生产单条件导入','Url_OrderMstr_Production',108,'非整车生产单条件导入','~/ProductionOrder/ConditionImport','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_OrderMstr_Production_ConditionImport','非整车生产单条件导入','Production')
go
