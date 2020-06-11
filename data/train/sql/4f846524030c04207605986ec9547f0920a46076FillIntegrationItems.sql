SET XACT_ABORT ON

insert into [SPD-NAV].[IntegrationDB_SPD].[dbo].[t_IntegrationItems] (
  [id]
  , [IDAnalitType]
  , [SessionId]
  , [SentDate])

SELECT an.id, an.IDAnalitType,NEWID(),GETDATE()
--Получаем СПДшные записи, которые есть в НСИ
 FROM NaviconMDM.dbo.CodesMappingDetails cd
JOIN [SPD-NAV].[GL_SPD].dbo.Analit an
ON cd.ClientId = CAST(an.id AS nvarchar(MAX))
--Делаем LEFT JOIN с IntegrationItems, затем выбираем те, что не сджойнились (Т.е. те, которых еще нет в интеграц. таблице)
LEFT JOIN [SPD-NAV].[IntegrationDB_SPD].[dbo].[t_IntegrationItems] itItems
ON itItems.id = an.id AND itItems.IDAnalitType = an.IDAnalitType
--Выбираем только те справочники, у которых PublisherName = 'SPD'
JOIN [SPD-NAV].[IntegrationDB_SPD].[dbo].[t_AnalitType] anType
ON anType.IDAnalitType = itItems.IDAnalitType AND anType.PublisherName = 'SPD'
WHERE cd.ClientName = 'SPD' 
AND itItems.id IS NULL 
--Кроме курсов валют. Они где-то не в Analit лежат.
AND cd.EntityName <> 'ExchangeRate'

UPDATE itItems
SET SessionId = NEWID(),
SentDate = GETDATE()
FROM NaviconMDM.dbo.CodesMappingDetails cd
JOIN [SPD-NAV].[GL_SPD].dbo.Analit an
ON cd.ClientId = CAST(an.id AS nvarchar(MAX))
--Делаем LEFT JOIN с IntegrationItems, затем выбираем те, что не сджойнились (Т.е. те, которых еще нет в интеграц. таблице)
JOIN [SPD-NAV].[IntegrationDB_SPD].[dbo].[t_IntegrationItems] itItems
ON itItems.id = an.id AND itItems.IDAnalitType = an.IDAnalitType
--Выбираем только те справочники, у которых PublisherName = 'SPD'
JOIN [SPD-NAV].[IntegrationDB_SPD].[dbo].[t_AnalitType] anType
ON anType.IDAnalitType = itItems.IDAnalitType AND anType.PublisherName = 'SPD'
WHERE cd.ClientName = 'SPD' 
--Кроме курсов валют. Они где-то не в Analit лежат.
AND cd.EntityName <> 'ExchangeRate'