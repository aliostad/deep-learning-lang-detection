Use Stage
GO

declare @viewName varchar(255)

declare cur CURSOR LOCAL READ_ONLY STATIC FOR
select name viewName
 from dbo.sysobjects o inner join INFORMATION_SCHEMA.VIEWS s on o.name=s.table_name 
 where o.type='v' and s.view_definition not like '%schemabinding%'


   OPEN cur
   FETCH NEXT FROM cur INTO @viewName

   WHILE @@FETCH_STATUS = 0
   BEGIN
          if (@viewName not like 'Cover%' )
			BEGIN
			 print @viewName
			 exec sp_refreshview @viewName
			END
          FETCH NEXT FROM cur INTO @viewName
   END
   CLOSE cur
   DEALLOCATE cur

GO
