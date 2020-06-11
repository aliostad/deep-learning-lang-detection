PRINT 'Filling FANSY RECODE TABLE:'

 --1. Перед выгрузкой необходимо ОДИН РАЗ заполнить перекодировочную таблицу для присвоения уникальных идентификаторов
 --   записям таблицы История ЦБ (OD_COUPONS). Перекодировочная таблица находится в БД Фэнси и вставленные ниже записи будут в дальнейшем использоваться Адаптером Фэнси. 
delete from [SDEPO-NAV].[X_DEPO_DATA].dbo.IdMappings where Entity = (select Id from [SDEPO-NAV].[X_DEPO_DATA].dbo.EntityDescription where EntityName = 'Ticker' and Direction = 'In');
insert into [SDEPO-NAV].[X_DEPO_DATA].dbo.IdMappings (Id, Entity, Key1, Key2, Key3) 
  select
      newid(), d.Id, c.SHARE, c.CODER, null
  from
      [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_VALUE_CODERS c
      inner join [SDEPO-NAV].[X_DEPO_DATA].dbo.EntityDescription d on d.EntityName = 'Ticker' and d.Direction = 'In';
