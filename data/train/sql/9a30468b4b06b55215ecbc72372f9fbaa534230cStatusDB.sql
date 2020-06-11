USE [SERVICES]
GO
/****** Object:  Table [dbo].[SERVICE_STATUS]    Script Date: 02/25/2010 12:37:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SERVICE_STATUS](
	[name] [varchar](50) NOT NULL,
	[status] [varchar](50) NOT NULL,
	[date] [datetime] NOT NULL,
 CONSTRAINT [PK_SERVICE_STATUS_1] PRIMARY KEY CLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[AppendLog]    Script Date: 02/25/2010 12:37:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AppendLog]

	@uid					VARCHAR(100),
	@log					VARCHAR(255),
	@logIdx					int
	
	
AS

	DECLARE @c INT
	SELECT @c = ISNULL(COUNT(uid), 0) FROM dbo.SERVICE_LOG
		WHERE uid = @uid AND logidx = @logidx
		
	IF @c >= 100
		DELETE dbo.SERVICE_LOG
			WHERE data = (
				SELECT MIN(data) FROM dbo.SERVICE_LOG
					WHERE uid = @uid AND logidx = @logidx
			);
	
	INSERT INTO dbo.SERVICE_LOG (
		uid,
		data,
		logidx,
		[log]
	) VALUES ( 
		@uid,
		GETDATE(),
		@logidx,
		@log );
GO
/****** Object:  StoredProcedure [dbo].[GetServiceCommand]    Script Date: 02/25/2010 12:37:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetServiceCommand]

	@uid		varchar(100)
	
AS

	DECLARE @res VARCHAR(50)	
	DECLARE @id		BIGINT;

	SELECT 
		TOP 1 
			@id = id,
			@res = cmd
	FROM dbo.SERVICE_CMD_QUEUE
	WHERE uid = @uid 
	ORDER BY id;
	
	IF (@id IS NOT NULL)
		DELETE dbo.SERVICE_CMD_QUEUE WHERE id = @id;
		
	SELECT @res;
GO
/****** Object:  StoredProcedure [dbo].[CleanStatus]    Script Date: 02/25/2010 12:37:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CleanStatus]

AS

	TRUNCATE TABLE SERVICE_STATUS;
GO
/****** Object:  StoredProcedure [dbo].[CHECK_SERVICES]    Script Date: 02/25/2010 12:37:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CHECK_SERVICES]

AS

	DECLARE @status	VARCHAR(50);
	DECLARE @date	DATETIME;	
	DECLARE @msg	VARCHAR(200);
	DECLARE @tmp	VARCHAR(50);		

	-- Controlla il guscio 
	SELECT	
			@status =	status,
			@date =		date 
	FROM SERVICE_STATUS
	WHERE [name] = 'ROOT';
	
	IF (ISNULL(@status, '') <> 'OK')
		BEGIN
			SELECT 'ERROR: Service status: '+ ISNULL(@status, '-- undefined --');
			RETURN; 
		END
	

	IF (@date IS NULL 			
			OR DATEADD(mi, -5, GETDATE()) > @date)
		BEGIN
			SELECT 'ERROR: Remoted service not responding';
			RETURN; 
		END;

	/*********************************************************
	 * Controlla i servizi
	 *********************************************************/
	
	-- Con errori
	IF EXISTS (SELECT * FROM SERVICE_STATUS WHERE NAME <> 'ROOT' AND status = 'ERROR')
		BEGIN
			
			SET @msg = '';
			SET @tmp = '';				
			DECLARE c CURSOR FOR
				SELECT name FROM SERVICE_STATUS WHERE NAME <> 'ROOT' AND status = 'ERROR';
					  
				OPEN c;
				FETCH NEXT FROM c
					INTO @tmp;					  

				WHILE @@FETCH_STATUS = 0
					BEGIN
					    SET @msg = @msg + ISNULL(@tmp, '');

						-- Get the next author.
						FETCH NEXT FROM c
						  INTO @tmp;
					END;					  

				CLOSE c;
				DEALLOCATE c;
				
				SELECT 'ERROR: Services: ' + @msg;
				RETURN; 
			
		END

	-- Con warning
	IF EXISTS (SELECT * FROM SERVICE_STATUS WHERE NAME <> 'ROOT' AND status IN ('STOPPED', 'SUSPENDED'))
		BEGIN
			
			SET @msg = '';
			SET @tmp = '';
			DECLARE c CURSOR FOR
				SELECT name FROM SERVICE_STATUS WHERE NAME <> 'ROOT' AND status IN ('STOPPED', 'SUSPENDED');
					  
				OPEN c;
				FETCH NEXT FROM c
					INTO @tmp;					  

				WHILE @@FETCH_STATUS = 0
					BEGIN
					    SET @msg = @msg + ISNULL(@tmp, '');

						-- Get the next author.
						FETCH NEXT FROM c
						  INTO @tmp;
					END;					  

				CLOSE c;
				DEALLOCATE c;
				
				SELECT 'WARNING: Services: ' + @msg;
				RETURN; 
			
		END

	SELECT 'OK';
GO
/****** Object:  StoredProcedure [dbo].[NotifyServiceStatus]    Script Date: 02/25/2010 12:37:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NotifyServiceStatus]
	
	@name		VARCHAR(50),
	@status		VARCHAR(50)
	
AS

	IF EXISTS (SELECT * FROM SERVICE_STATUS WHERE [name] = @name)
	  BEGIN
	  	
	  	UPDATE SERVICE_STATUS SET
	  		status = @status,
	  		date = GETDATE()
	  	WHERE [name] = @name;
	  	
	  END
	ELSE
	  BEGIN
	  	
	  	INSERT INTO SERVICE_STATUS (
		  	[name],
		  	status,
		  	date
		  ) VALUES ( 
		  	@name,
		  	@status,
		  	GETDATE());
	  	
	  END
GO
/****** Object:  StoredProcedure [dbo].[NotifyRootStatus]    Script Date: 02/25/2010 12:37:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[NotifyRootStatus]
	
	@status		VARCHAR(50)
	
AS

	EXEC dbo.NotifyServiceStatus 'ROOT', @status;
GO
