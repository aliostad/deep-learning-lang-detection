
update sys_menu set name ='整车下线',desc1 ='整车下线' where code ='Url_OrderMstr_Production_Receive'
update acc_permission set desc1 ='整车下线' where code ='Url_OrderMstr_Production_Receive'
go

insert into sys_menu values
('Url_OrderMstr_Production_NonVanReceive','非整车生产单报工','Url_OrderMstr_Production',199,'非整车生产单报工','~/ProductionOrder/NonVanReceiveIndex','~/Content/Images/Nav/Default.png',1)
insert into acc_permission values('Url_OrderMstr_Production_NonVanReceive','非整车生产单报工','Production')
go
