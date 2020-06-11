alter database channeldb10
set single_user with rollback immediate

alter database channeldb10 modify filegroup FG01  read_only
alter database channeldb10 modify filegroup FG02  read_only 
alter database channeldb10 modify filegroup FG03  read_only 
alter database channeldb10 modify filegroup FG04  read_only 
alter database channeldb10 modify filegroup FG05  read_only 
alter database channeldb10 modify filegroup FG06  read_only 
alter database channeldb10 modify filegroup FG07  read_only 
alter database channeldb10 modify filegroup FG08  read_only 
alter database channeldb10 modify filegroup FG09  read_only 
alter database channeldb10 modify filegroup FG10  read_only 
alter database channeldb10 modify filegroup FG11  read_only 
alter database channeldb10 modify filegroup FG12  read_only 
alter database channeldb10 modify filegroup FG13  read_only 
alter database channeldb10 modify filegroup FG14  read_only 
alter database channeldb10 modify filegroup FG15  read_only 
alter database channeldb10 modify filegroup FG16  read_only 
alter database channeldb10 modify filegroup FG17  read_only 
alter database channeldb10 modify filegroup FG18  read_only 
alter database channeldb10 modify filegroup FG19  read_only 
alter database channeldb10 modify filegroup FG20  read_only 
alter database channeldb10 modify filegroup FG21  read_only 
alter database channeldb10 modify filegroup FG22  read_only 
alter database channeldb10 modify filegroup FG23  read_only 
alter database channeldb10 modify filegroup FG24  read_only 


alter database channeldb10 set multi_user

alter database channeldb10 set recovery full;