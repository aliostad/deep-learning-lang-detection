select COUNT(D.Vphd_View_SSPI)
from 

( 
SELECT Vphd_View_SSPI, Vphd_View_Last_Exit_Date,  Vphd_View_Event_Origin_Date
	from dbo.VSPC_ProcessHistoryArchive_View
WHERE Vphd_View_Event_Description = 'post retail sale processing' AND Vphd_View__Program_Number = '102'

union

SELECT Vphd_View_SSPI, Vphd_View_Last_Exit_Date, Vphd_View_Event_Origin_Date
    from dbo.VSPC_ProcessHistoryDetail_View
WHERE Vphd_View_Event_Description = 'post retail sale processing' AND Vphd_View__Program_Number = '102'



) AS D
--WHERE D.Vphd_View_Event_Origin_Date BETWEEN '2012-06-01' AND '2012-10-01'
where D.Vphd_View_Last_Exit_Date is not null

----------
-----------

select D.Vphd_View_SSPI, D.Vphd_View_Last_Exit_Date
from 

( 
SELECT Vphd_View_SSPI, Vphd_View_Last_Exit_Date,  Vphd_View_Event_Origin_Date
	from dbo.VSPC_ProcessHistoryArchive_View
WHERE Vphd_View_Event_Description = 'post retail sale processing' AND Vphd_View__Program_Number = '102'

union

SELECT Vphd_View_SSPI, Vphd_View_Last_Exit_Date, Vphd_View_Event_Origin_Date
    from dbo.VSPC_ProcessHistoryDetail_View
WHERE Vphd_View_Event_Description = 'post retail sale processing' AND Vphd_View__Program_Number = '102'



) AS D
--WHERE D.Vphd_View_Event_Origin_Date BETWEEN '2012-06-01' AND '2012-10-01'
where D.Vphd_View_Last_Exit_Date is not null

ORDER BY D.Vphd_View_SSPI