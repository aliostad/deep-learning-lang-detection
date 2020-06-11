cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition –Parent)

Import-Module "$currentPath\..\SQLHelper.psm1" -Force

$sourceConnStr = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=AdventureWorksDW2012;Data Source=.\sql2014"

# Execute the query

$data = Invoke-SQLCommand -executeType QueryAsTable -connectionString $sourceConnStr -commandText "select * from dbo.DimProduct" -Verbose

# Show the data

$data | Select ProductKey, EnglishProductName, ListPrice | Out-GridView