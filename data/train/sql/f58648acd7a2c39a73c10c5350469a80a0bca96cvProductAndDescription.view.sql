CREATE VIEW [SalesLT].[vProductAndDescription] 
WITH SCHEMABINDING 
AS 
SELECT 
p.[ProductID] 
,p.[Name] 
,pm.[Name] AS [ProductModel] 
,pmx.[Culture] 
,pd.[Description] 
FROM [SalesLT].[Product] p 
INNER JOIN [SalesLT].[ProductModel] pm 
ON p.[ProductModelID] = pm.[ProductModelID] 
INNER JOIN [SalesLT].[ProductModelProductDescription] pmx 
ON pm.[ProductModelID] = pmx.[ProductModelID] 
INNER JOIN [SalesLT].[ProductDescription] pd 
ON pmx.[ProductDescriptionID] = pd.[ProductDescriptionID];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Product names and descriptions. Product descriptions are provided in multiple languages.', @level0type = N'SCHEMA', @level0name = N'SalesLT', @level1type = N'VIEW', @level1name = N'vProductAndDescription';

