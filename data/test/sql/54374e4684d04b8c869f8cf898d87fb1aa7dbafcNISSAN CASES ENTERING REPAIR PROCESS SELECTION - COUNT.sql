SELECT 
SSPI_CLientOrgAreaCode01 AS REGION,
count (Vphd_View_SSPI)AS CASES

--Vphd_View_SSPI, 
--SSPI_IDNT, 
--Vphd_View_Last_Entry_Date,Vphd_View__Program_Number,
--Vphd_View_Program_Name,


FROM dbo.VSPC_ProcessHistoryDetail_View 
inner join sspi
on Vphd_View_SSPI = sspi_idnt

WHERE Vphd_View_System_EventId = 55
and Vphd_View_Last_Entry_Date between '2013-10-01' and '2014-01-01'
and
  SSPI_PRGM_IDNT = 102 
  AND SSPICurrentStatusFK IN (78, 79)

group by SSPI_CLientOrgAreaCode01

order by 
SSPI_CLientOrgAreaCode01--,
--Vphd_View_Last_Entry_Date
