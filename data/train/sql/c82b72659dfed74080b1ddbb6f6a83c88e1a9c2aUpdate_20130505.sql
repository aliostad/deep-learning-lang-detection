alter table  ord_po add ReceiveQty decimal (18,8) null;
go
insert into ACC_Permission values('Url_KanbanCard_ExportSemiProductKB','导出生产看板','Kanban')
go
insert into ACC_Permission values('Url_KanbanCard_ExportStampingKB','导出冲压物流看板','Kanban')
go
insert into ACC_Permission values('Url_KanbanCard_ExportAssemblyKB','导出总装看板卡','Kanban')
go
insert into ACC_Permission values('Url_KanbanCard_ExportWeldKB','导出焊装看板卡','Kanban')
go
insert into sys_menu values('Menu.Inventory.DailyTrans','日交易报表查询','Menu.Inventory.Info',31700,'日交易报表查询','~/LocationTransaction/IndexDailyTrans','~/Content/Images/Nav/Trans.png',1)
go
insert into ACC_Permission values('Menu.Inventory.DailyTrans','日交易报表查询','Order')