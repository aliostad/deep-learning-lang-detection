SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [logging].[sp_dp_prodconfirm] AS

DECLARE @table AS TABLE(Emp_Email NVARCHAR(100), ID int IDENTITY(1,1))

--populate the above table
INSERT @table (Emp_Email) VALUES('nhall@wirelessadvocates.com')

DECLARE @count AS int
SET @count =1 --initialize the count parameter
DECLARE @Recepient_Email AS VARCHAR(100)
WHILE (@count <=(SELECT COUNT(*) FROM @table))
        BEGIN
        SET @Recepient_Email =(SELECT TOP(1) Emp_Email FROM @table WHERE ID=@count)

DECLARE @subjtext AS NVARCHAR(255)
SELECT @subjtext = CONVERT(VARCHAR(10),MAX(Timestamp),101) + ': Completion of Data Push to ' + Pushed FROM logging.DataPush GROUP BY Pushed

EXECUTE msdb.dbo.sp_send_dbmail
    @recipients = @Recepient_Email,
    @subject = @subjtext,
    @profile_name = 'Default',
    @body_format = 'html',
    @exclude_query_output = 1,
    @append_query_error = 1,
    @body = 'Changes have been pushed to Costco at <a href="http://www.membershipwireless.com">http://www.membershipwireless.com</a> and AAFES at <a href="http://www.aafesmobile.com">http://www.aafesmobile.com</a>.'

	
            SET @count = @count + 1
            END
GO
