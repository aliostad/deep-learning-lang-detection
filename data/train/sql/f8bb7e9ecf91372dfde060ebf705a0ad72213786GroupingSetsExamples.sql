

--In order to get "totals" for territory group and a grand total, we normally append different queries
SELECT 
TerritoryGroup,
TerritoryName AS TerritoryName,
SUM(SalesYTD) AS TotalSales
FROM Sales.vSalesPerson
WHERE TerritoryGroup IS NOT null
GROUP BY TerritoryGroup,TerritoryName
union

SELECT 
TerritoryGroup,
NULL AS TerritoryName,
SUM(SalesYTD) AS TotalSales
FROM Sales.vSalesPerson
WHERE TerritoryGroup IS NOT null
GROUP BY TerritoryGroup
UNION 

SELECT 
NULL AS TerritoryGroup,
NULL AS TerritoryName,
SUM(SalesYTD) AS TotalSales
FROM Sales.vSalesPerson

--but we can do the same thing in a single query using grouping sets
SELECT  
TerritoryName,
TerritoryGroup,
SUM(SalesYTD) AS TotalSales
FROM Sales.vSalesPerson
WHERE TerritoryGroup IS NOT NULL AND TerritoryName IS NOT null
GROUP BY GROUPING SETS ((TerritoryName,TerritoryGroup),(TerritoryName),())
