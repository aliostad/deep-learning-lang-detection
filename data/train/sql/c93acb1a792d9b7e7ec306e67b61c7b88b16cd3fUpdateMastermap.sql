-- ***********************************************
-- NAME 	: UpdateESRI.sql
-- DESCRIPTION 	: Updates mastermap database, adds sprocs
--		: and ASPUSER
-- ************************************************
-- $Log:   P:/TDPortal/archives/DotNet2.0Codebase/TransportDirect/Resource/DEL8_2/InitialDBStructure/UpdateMastermap.sql-arc  $
--
--   Rev 1.0   Nov 08 2007 12:42:24   mturner
--Initial revision.

USE [mastermap]
GO

-- CREATE access for domain user ASPUSER

DECLARE @ASPUser nvarchar(100)
SELECT @ASPUser=DMZDomainName + '\ASPUSER' from master.dbo.Environment

if not exists (select * from dbo.sysusers where name = N'ASPUSER' and uid < 16382)
	EXEC sp_grantdbaccess @ASPUser, N'ASPUSER'
GO

exec sp_addrolemember N'db_owner', N'ASPUSER'
GO


/****** Object:  Stored Procedure dbo.usp_Save_To_PT_TABLE    Script Date: 01/09/2003 16:33:30 ******/
CREATE PROCEDURE dbo.usp_Save_To_PT_TABLE ( 	@SESSIONID varchar(32),
				             	@ROUTENUM int,
				             	@LEGNO bigint,
				             	@LEGMODE varchar(16),
						@POINTORDER bigint,
						@EASTING float,
						@NORTHING float )
AS
	-- Test for an existing entry
	IF EXISTS (SELECT SESSIONID FROM mapadmin.PT_ROUTES
        	    WHERE SESSIONID = @SESSIONID
		      AND ROUTENUM = @ROUTENUM
		      AND LEGNO = @LEGNO
		      AND POINTORDER = @POINTORDER)

	BEGIN -- UPDATE an existing entry

		UPDATE mapadmin.PT_ROUTES
		   SET LEGMODE = @LEGMODE,
		       POINTORDER = @POINTORDER,
		       EASTING = @EASTING,
		       NORTHING = @NORTHING
        	 WHERE SESSIONID = @SESSIONID
		   AND ROUTENUM = @ROUTENUM
		   AND LEGNO = @LEGNO
	           AND POINTORDER = @POINTORDER

	END
	ELSE
	BEGIN -- APPEND a new record

		INSERT INTO mapadmin.PT_ROUTES(SESSIONID, ROUTENUM, LEGNO, LEGMODE, POINTORDER, EASTING, NORTHING)
		     VALUES(@SESSIONID, @ROUTENUM, @LEGNO, @LEGMODE, @POINTORDER, @EASTING, @NORTHING)

	END
GO

/****** Object:  Stored Procedure dbo.usp_Save_To_RD_TABLE    Script Date: 01/09/2003 16:33:30 ******/
CREATE PROCEDURE dbo.usp_Save_To_RD_TABLE ( 	@SESSIONID varchar(32),
							@ROUTENUM int,
							@TOID varchar(16),
							@CONGESTION int)
AS

	-- Test for an existing entry
	IF EXISTS (SELECT SESSIONID FROM mapadmin.RD_ROUTES
        	    WHERE SESSIONID = @SESSIONID
		      AND ROUTENUM = @ROUTENUM
		      AND TOID = @TOID)

	BEGIN -- UPDATE an existing entry

		UPDATE mapadmin.RD_ROUTES
		   SET TOID = @TOID,
		       CONGESTION = @CONGESTION
        	 WHERE SESSIONID = @SESSIONID
		   AND ROUTENUM = @ROUTENUM
		   AND TOID = @TOID
	END
	ELSE
	BEGIN -- APPEND a new record

		INSERT INTO mapadmin.RD_ROUTES(SESSIONID, ROUTENUM, TOID, CONGESTION)
		     VALUES(@SESSIONID, @ROUTENUM, @TOID, @CONGESTION)

	END
GO
