----------------- cleanup ----------------------------------

IF OBJECT_ID('dbo.customers','U') IS NOT NULL  
DROP TABLE dbo.customers

IF OBJECT_ID('dbo.customers_new','U') IS NOT NULL  
DROP TABLE dbo.customers_new

IF OBJECT_ID('dbo.vw_customers','V') IS NOT NULL drop view dbo.vw_customers
;

IF OBJECT_ID('dbo.vw_customers_new','V') IS NOT NULL drop view dbo.vw_customers_new
;

IF OBJECT_ID('dbo.usp_find_customers','P') IS NOT NULL drop procedure dbo.usp_find_customers
;

IF OBJECT_ID('dbo.usp_find_customers_new','P') IS NOT NULL drop procedure dbo.usp_find_customers_new
;

IF OBJECT_ID('dbo.CalMonthByYearMonth','P') IS NOT NULL drop procedure dbo.CalMonthByYearMonth
;
