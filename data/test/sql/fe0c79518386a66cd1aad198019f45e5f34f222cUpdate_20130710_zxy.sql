update sys_menu set name ='整车生产单下线',desc1='整车生产单下线' where code ='Url_OrderMstr_Production_Receive'
go
update acc_permission set desc1 ='整车生产单下线' where code ='Url_OrderMstr_Production_Receive'
go



 insert into sys_menu values
 ('Url_OrderMstr_Production_VanReceiveCancel','整车生产单报工取消','Url_OrderMstr_Production',200,'整车生产单报工取消','~/ProductionOrder/VanReceiveCancelIndex','~/Content/Images/Nav/Default.png',1)
 go
 
 insert into acc_permission values('Url_OrderMstr_Production_VanReceiveCancel','整车生产单报工取消','Production')
 go