select COUNT(D.Vphd_View_SSPI)
from 


( 
SELECT Vphd_View_SSPI, Vphd_View_Last_Exit_Date,  Vphd_View_Event_Origin_Date, Vphd_View_System_EventId, Vphd_View_Event_Description, Vphd_View_Last_Entry_Date
	from dbo.VSPC_ProcessHistoryArchive_View

WHERE Vphd_View_System_EventId = '19' AND Vphd_View__Program_Number = '102'
--WHERE Vphd_View_Event_Description = 'post disposition processing' AND Vphd_View__Program_Number = '102'

union

SELECT Vphd_View_SSPI, Vphd_View_Last_Exit_Date, Vphd_View_Event_Origin_Date, Vphd_View_System_EventId, Vphd_View_Event_Description, Vphd_View_Last_Entry_Date
    from dbo.VSPC_ProcessHistoryDetail_View

--WHERE Vphd_View_Event_Description = 'post disposition processing' AND Vphd_View__Program_Number = '102'

WHERE Vphd_View_System_EventId = '19' AND Vphd_View__Program_Number = '102'


) AS D
--WHERE D.Vphd_View_Event_Origin_Date BETWEEN '2012-06-01' AND '2012-10-01'
INNER JOIN dbo.SSPI
    ON SSPI_IDNT = D.Vphd_View_SSPI
--    AND
--    SSPICurrentStatusFK NOT IN (99, 191, 80)    --No Test Cases, Non-Reportable

where 
D.Vphd_View_Last_Entry_Date between '2013-03-01' and '2013-03-31'
--D.Vphd_View_Event_Origin_Date between '2013-03-01' and '2013-03-31'

----------





-----------

select 
    D.Vphd_View_SSPI AS CASE_NUM, 
    D.Vphd_View_System_EventId AS QUEUE_NUM, 
    D.Vphd_View_Event_Description AS QUEUE,
    D.Vphd_View_Event_Origin_Date AS ORIG_DATE,
    D.Vphd_View_Last_Entry_Date AS ENTRY_DATE,
    D.Vphd_View_Last_Exit_Date AS EXIT_DATE, 
    SSPICurrentStatusFK AS STATUS
from 

( 
SELECT Vphd_View_SSPI, Vphd_View_Last_Exit_Date,  Vphd_View_Event_Origin_Date, Vphd_View_System_EventId, Vphd_View_Event_Description, Vphd_View_Last_Entry_Date
	from dbo.VSPC_ProcessHistoryArchive_View

WHERE Vphd_View_System_EventId = '19' AND Vphd_View__Program_Number = '102'
--WHERE Vphd_View_Event_Description = 'post disposition processing' AND Vphd_View__Program_Number = '102'

union

SELECT Vphd_View_SSPI, Vphd_View_Last_Exit_Date, Vphd_View_Event_Origin_Date, Vphd_View_System_EventId, Vphd_View_Event_Description, Vphd_View_Last_Entry_Date
    from dbo.VSPC_ProcessHistoryDetail_View

--WHERE Vphd_View_Event_Description = 'post disposition processing' AND Vphd_View__Program_Number = '102'

WHERE Vphd_View_System_EventId = '19' AND Vphd_View__Program_Number = '102'


) AS D
--WHERE D.Vphd_View_Event_Origin_Date BETWEEN '2012-06-01' AND '2012-10-01'

INNER JOIN dbo.SSPI
    ON SSPI_IDNT = D.Vphd_View_SSPI
--    AND
--    SSPICurrentStatusFK NOT IN (99, 191, 80)    --No Test Cases, Non-Reportable

where 
    D.Vphd_View_Last_Entry_Date between '2013-03-01' and '2013-03-31'
--D.Vphd_View_Event_Origin_Date between '2013-03-01' and '2013-03-31'
--D.Vphd_View_Last_Exit_Date is not null

ORDER BY 
    D.Vphd_View_Last_Entry_Date
--    D.Vphd_View_SSPI