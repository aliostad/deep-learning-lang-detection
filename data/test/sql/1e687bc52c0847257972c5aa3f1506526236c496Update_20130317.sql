alter table MD_FinanceCalendar add Version int
go
update MD_FinanceCalendar set Version = 1
go
alter table MD_FinanceCalendar alter column Version int not null
go
go
insert into SYS_Menu values('Url_MiscTransferOrder_FixNew','整修件移转单新建','Url_MiscOrder_MiscTransferOrder',21000,'整修件移转单新建','~/MiscTransferOrder/FixNew','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_MiscTransferOrder_FixNew','整修件移转单新建','MiscOrder')
go
go
insert into SYS_Menu values('Url_TransferItemDailyConsume_View','工位日用量错误日志','Menu.Kanban.Info',5000,'工位日用量错误日志','~/TransferItemDailyConsume/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_TransferItemDailyConsume_View','工位日用量错误日志','Production')
go