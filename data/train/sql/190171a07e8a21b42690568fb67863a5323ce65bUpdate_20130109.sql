

insert into sys_menu values
('Url_OrderMstr_Production_ItemView','整车生产单查询','Url_OrderMstr_Production',102,'整车生产单查询','~/ProductionOrder/ItemIndex','~/Content/Images/Nav/Default.png',1)

if not exists(select * from acc_permission where code='Url_OrderMstr_Production_ItemView')
insert into acc_permission values('Url_OrderMstr_Production_ItemView','整车生产单查询','Production')

-- 月结
update sys_menu set isactive =1  where  code='Url_FinanceCalendar_Close'
--会计区间（财政月）
update sys_menu set isactive =1  where  code='Url_FinanceCalendar_View'

-- 去掉电子看板超合约报表
update sys_menu set isactive =0  where  code='Url_OrderMstr_Procurement_ElecKBOverSA'

insert into sys_menu values
('Url_OrderOverFlow_View','超合约报表','Menu.Procurement.Info',3,'超合约报表','~/OrderOverFlow/Index','~/Content/Images/Nav/Default.png',1)

if not exists(select * from acc_permission where code='Url_OrderOverFlow_View')
	insert into acc_permission values ('Url_OrderOverFlow_View','超合约报表','Procurement')

insert into sys_menu values
('KanbanCard_ProcurementOrder_New','创建看板收料单','Url_OrderMstr_Procurement',110,'创建看板收料单','~/ProcurementOrder/KBReceptionIndex','~/Content/Images/Nav/Default.png',1)

if not exists(select * from acc_permission where code='KanbanCard_ProcurementOrder_New')
	insert into acc_permission values('KanbanCard_ProcurementOrder_New','创建看板收料单','Procurement')

insert into SYS_Menu values('Url_OrderMstr_Production_VanOrderSeqView', '整车车序查询', 'Url_OrderMstr_Production', 104, '总装生产单顺序查询', '~/ProductionOrder/VanOrderSeqIndex', '~/Content/Images/Nav/Default.png', 1)
insert into ACC_Permission values('Url_OrderMstr_Production_VanOrderSeqView', '整车车序查询', 'Production')


go

alter table CUST_ItemDailyConsume add OriginalQty decimal(18,8)
go