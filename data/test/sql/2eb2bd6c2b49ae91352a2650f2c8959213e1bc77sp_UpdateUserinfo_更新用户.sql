SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[sp_UpdateUserinfo]
		@OldUsercode varchar(50),
		@NewUsercode varchar(50),
		@NewUserName varchar(50),
		@NewPassword varchar(50),
		@NewCompanyName varchar(50),
		@NewTel varchar(50),
		@NewEmail varchar(50),
		@NewIsAdmin bit,
		@NewsStatus varchar(50),
		@NewDistributionMode varchar(20)='节省资源',
		@NewLimitPerday int,
		@NewTotalLimit bigint=0,
		@NewNofityNewMessage bit =0,
		@NewShowEchoInfo bit=0, 
		@NewRemark varchar(200)
	as
		BEGIN
			update t_User
				set usercode=@NewUsercode,
				username=@NewUserName,
				password=@NewPassword,
				companyname=@newcompanyname,
				tel=@NewTel,
				email=@NewEmail,
				status=@NewsStatus,
				isadmin=@NewIsAdmin,
				limitperday=@NewLimitPerday,
				totallimit=@NewTotalLimit,
				DistributionMode=@NewDistributionMode,
				NofityNewMessage=@NewNofityNewMessage,
				ShowEchoInfo=@NewShowEchoInfo,
				remark=@NewRemark
			where usercode=@OldUsercode
			return
		END