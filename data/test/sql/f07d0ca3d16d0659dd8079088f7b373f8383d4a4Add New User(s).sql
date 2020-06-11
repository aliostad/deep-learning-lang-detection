


-- <Username,sysname,EXCO\PointCross_DatabaseReadOnly>
-- <Database,sysname,CNS_>
-- <SQLServer,sysname,EX30SQLDV01>
-- <Role,sysname,db_datareader>

DECLARE @mDatabase SYSNAME


USE master

IF @@servername = '<SQLServer,sysname,>' 
    BEGIN

		IF EXISTS ( SELECT
						*
					FROM
						sys.server_principals
					WHERE
						name = N'<Username,sysname,EXCO\BI_DatabaseReadOnly>' ) 
			DROP LOGIN [<Username,sysname,EXCO\BI_DatabaseReadOnly>]
			PRINT 'Dropped login <Username,sysname,EXCO\BI_DatabaseReadOnly>'

		CREATE LOGIN [<Username,sysname,EXCO\BI_DatabaseReadOnly>] FROM WINDOWS
			WITH DEFAULT_DATABASE= [master],
				 DEFAULT_LANGUAGE= [us_english]
		PRINT 'Created login <Username,sysname,EXCO\BI_DatabaseReadOnly>'         


        SELECT
            @mDatabase = '<Database,sysname,>'
        USE <Database,sysname,>

        IF EXISTS ( SELECT
                        *
                    FROM
                        sys.database_principals
                    WHERE
                        name = '<Username,sysname,>'
                        AND DB_NAME() = @mDatabase ) 
            BEGIN
                DROP USER [EXCO\BI_DatabaseReadOnly]
                PRINT 'Dropped user in database ' + DB_NAME()
            END
		
        IF DB_NAME() = @mDatabase 
            BEGIN
				
                CREATE USER [<Username,sysname,>] FOR LOGIN [<Username,sysname,>]
				PRINT 'Created user in database ' + DB_NAME()
				
                EXEC sp_addrolemember N'<Role,sysname,db_datareader>', N'<Username,sysname,>'
                
                IF IS_MEMBER('<Role,sysname,db_datareader>') = 1
                 PRINT '  and is member of <Role,sysname,db_datareader>'
                 ELSE PRINT '  BUT IS NOT a member of <Role,sysname,db_datareader>'
        
            END

    END
    
    PRINT ''
    
    GO