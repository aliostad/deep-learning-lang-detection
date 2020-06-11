

CREATE VIEW [dbo].[TREE_prepods]
AS
SELECT     TOP (100) PERCENT RTRIM(EmployeeView.LastName) + ' ' + RTRIM(EmployeeView.FirstName) + ' ' + RTRIM(EmployeeView.Otch) 
                      + ' (таб. № ' + CONVERT(nvarchar, EmployeeView.itab_n) + ')' AS FIO, EmployeeView.itab_n, 
                      EmployeeView.LastName clastname, EmployeeView.FirstName cfirstname, 
                      EmployeeView.Otch cotch, null ik_rank, null ik_degree
FROM         dbo.EmployeeView 
where   LastName IS NOT NULL AND  FirstName IS NOT NULL AND Otch IS NOT NULL AND 
itab_n IS NOT NULL
ORDER BY FIO


