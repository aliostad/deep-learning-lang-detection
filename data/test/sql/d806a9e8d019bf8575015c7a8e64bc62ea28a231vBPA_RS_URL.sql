CREATE VIEW
    dbo.vBPA_RS_URL
AS
-- Construct the Reporting Services URL from the SQL server (instance) name.
SELECT
    'http://'
        + CASE
            WHEN CHARINDEX( '\', @@SERVERNAME) <> 0 -- We have an instance of SQL Server, we need to snip off the instance name and then append it to the "Reports" in the RS URL.
                THEN SUBSTRING(@@SERVERNAME, 0, CHARINDEX( '\', @@SERVERNAME)) + '/ReportServer_' + SUBSTRING(@@SERVERNAME, (CHARINDEX( '\', @@SERVERNAME)+1), LEN(@@SERVERNAME)) -- For SQL Server 2005, replace 'ReportServer_' with 'ReportServer$'.
            ELSE @@SERVERNAME + '/ReportServer'
            END
        + '/Pages/ReportViewer.aspx?/'
        AS RS_URL
