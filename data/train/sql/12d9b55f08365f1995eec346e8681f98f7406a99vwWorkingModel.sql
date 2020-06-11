print '%Creating view% vwWorkingModel'
GO
IF object_id(N'dbo.vwWorkingModel', 'V') IS NOT NULL
	DROP VIEW dbo.vwWorkingModel
GO

CREATE VIEW dbo.vwWorkingModel AS
	select wm.WorkingModelID, CountryID, Data, ConditionType, MultiplyValue, AddValue ,BeginTime, EndTime, AddCharges, wmn.LanguageID, [Name], [Message], UseInRecording, WorkingModelType
	from dbo.WorkingModel wm
	left outer join dbo.WorkingModelName wmn
	on
		wm.WorkingModelID = wmn.WorkingModelID
	left outer join dbo.WorkingModelMessage m
	on
		m.WorkingModelID = wm.WorkingModelID
		and m.LanguageID = wmn.LanguageID
GO

IF OBJECT_ID ('dbo.vwWorkingModel_delete','TR') IS NOT NULL
   DROP TRIGGER dbo.vwWorkingModel_delete
GO

create trigger dbo.vwWorkingModel_delete on dbo.vwWorkingModel instead of delete as
  set nocount on
  delete from
    dbo.WorkingModelName
  where
    (WorkingModelID in (select WorkingModelID from deleted))

  delete from
    dbo.WorkingModelMessage
  where
    (WorkingModelID in (select WorkingModelID from deleted))
 
  delete from
    dbo.WorkingModel
  where
    (WorkingModelID in (select WorkingModelID from deleted))
GO

IF OBJECT_ID ('dbo.vwWorkingModel_insert','TR') IS NOT NULL
   DROP TRIGGER dbo.vwWorkingModel_insert
GO

create trigger dbo.vwWorkingModel_insert on dbo.vwWorkingModel instead of insert as
  set nocount on
	
	declare @newID bigint
	set @newID = -1

	insert into dbo.WorkingModel(WorkingModelID, CountryID, Data, ConditionType, MultiplyValue, AddValue, BeginTime, EndTime, AddCharges, UseInRecording, WorkingModelType)
	select WorkingModelID, CountryID, Data, ConditionType, MultiplyValue, AddValue, BeginTime, EndTime, AddCharges, UseInRecording, WorkingModelType from inserted

	--WorkingModelName
	select @newID = wmn.Id from dbo.WorkingModelName wmn 
	inner join inserted i
	on
		wmn.WorkingModelID = i.WorkingModelID 
		and wmn.LanguageID = i.LanguageID

	if @newID = -1
	begin 
		exec getNewID @newID output
		insert into dbo.WorkingModelName (Id, WorkingModelID, LanguageID, [Name])
		select @newID, WorkingModelID, LanguageID, [Name] from inserted 
		where not exists(select * from dbo.WorkingModelName wmn where wmn.WorkingModelID = inserted.WorkingModelID and wmn.LanguageID = inserted.LanguageID)
	end
	else begin
		update dbo.WorkingModelName	
		set
			[Name] = i.[Name]
		from WorkingModelName wmn 
		inner join inserted i
		on
			wmn.WorkingModelID = i.WorkingModelID 
			and wmn.LanguageID = i.LanguageID
	end

	--WorkingModelMessage
	if not exists (select * from dbo.WorkingModelMessage wmn 
				inner join inserted i
				on
					wmn.WorkingModelID = i.WorkingModelID 
					and wmn.LanguageID = i.LanguageID
	)
	begin
		insert into dbo.WorkingModelMessage (WorkingModelID, LanguageID, [Message])
		select WorkingModelID, LanguageID, [Message] from inserted 
	end
	else begin
		update dbo.WorkingModelMessage	
		set
			[Message] = i.[Message]
		from WorkingModelMessage m 
		inner join inserted i
		on
			m.WorkingModelID = i.WorkingModelID 
			and m.LanguageID = i.LanguageID
	end

GO

IF OBJECT_ID ('dbo.vwWorkingModel_update','TR') IS NOT NULL
   DROP TRIGGER dbo.vwWorkingModel_update
GO

create trigger dbo.vwWorkingModel_update on dbo.vwWorkingModel instead of update as
  set nocount on
  declare @newID bigint
  set @newID = -1

  update dbo.WorkingModel
	set
      [CountryID] = i.[CountryID]
      ,[Data] = i.[Data]
      ,[ConditionType] = i.[ConditionType]
      ,[MultiplyValue] = i.[MultiplyValue]
      ,[AddValue] = i.[AddValue]
	  ,BeginTime = i.BeginTime
      ,EndTime = i.EndTime
	  ,AddCharges = i.AddCharges
	  ,UseInRecording = i.UseInRecording
	  ,WorkingModelType = i.WorkingModelType
	from dbo.WorkingModel wm 
	inner join inserted i
	on
		wm.WorkingModelID = i.WorkingModelID

	--WorkingModelName
	select @newID = wmn.Id from dbo.WorkingModelName wmn 
	inner join inserted i
	on
		wmn.WorkingModelID = i.WorkingModelID 
		and wmn.LanguageID = i.LanguageID

	if @newID = -1
	begin 
		exec getNewID @newID output
		insert into dbo.WorkingModelName (Id, WorkingModelID, LanguageID, [Name])
		select @newID, WorkingModelID, LanguageID, [Name] from inserted 
		where not exists(select * from dbo.WorkingModelName wmn where wmn.WorkingModelID = inserted.WorkingModelID and wmn.LanguageID = inserted.LanguageID)
	end
	else begin
		update dbo.WorkingModelName	
		set
			[Name] = i.[Name]
		from WorkingModelName wmn 
		inner join inserted i
		on
			wmn.WorkingModelID = i.WorkingModelID 
			and wmn.LanguageID = i.LanguageID
	end
 
	--WorkingModelMessage
	if not exists (select * from dbo.WorkingModelMessage wmn 
				inner join inserted i
				on
					wmn.WorkingModelID = i.WorkingModelID 
					and wmn.LanguageID = i.LanguageID
	)
	begin
		insert into dbo.WorkingModelMessage (WorkingModelID, LanguageID, [Message])
		select WorkingModelID, LanguageID, [Message] from inserted 
	end
	else begin
		update dbo.WorkingModelMessage	
		set
			[Message] = i.[Message]
		from WorkingModelMessage m 
		inner join inserted i
		on
			m.WorkingModelID = i.WorkingModelID 
			and m.LanguageID = i.LanguageID
	end

GO
