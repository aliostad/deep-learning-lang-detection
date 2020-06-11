$xenapp_server = '@@YOURSERVNAME@@'
$db_output = '@@YOURSQLNAME@@'
$db_tablename = "@@[database_you_make].[dbo].[table_you_make]@@"
$db_catalog = '@@YOUR_DB_NAME@@'
$citrix = New-PSSession -ComputerName $xenapp_server
$citrix_Array = @()

$citrix_array += @(Invoke-Command -Session $citrix -ScriptBlock {Add-PSSnapin citrix.xenapp.commands
    $app_policy = Get-XALoadEvaluator -LoadEvaluatorName '@@YOUR LOAD EVALUATOR NAME@@'
    
    $app_servers = Get-XAServer -BrowserName "@@YOUR BROWSER NAME@@"
    foreach($app_serv in $app_servers){
        $app_sesh = get-xasession -ServerName $app_serv.servername
        $line = New-Object PSObject
        $line | Add-Member -MemberType NoteProperty -Name 'servername' -Value "$($app_serv.servername)"
        $line | Add-Member -MemberType NoteProperty -Name 'sessioncount' -Value "$($app_sesh.count)"
        $line | Add-Member -MemberType NoteProperty -Name 'loadcount' -Value "$($app_policy.serveruserload)"
        $line | Add-Member -MemberType NoteProperty -name 'CPU Utilizaton' -Value $CPU
        $line
    }
    
})
foreach($c in $citrix_Array){
$CPU = (Get-WmiObject -ComputerName $C.servername Win32_Processor).LoadPercentage
Invoke-Sqlcmd -ServerInstance $db_output -Database $db_catalog  -Query "insert into $db_tablename (APP_Server, APP_Session_count, APP_Load_limit, timestamp, CPU_1, CPU_2) values ('$($c.servername)',$($c.sessioncount),$($c.loadcount), getdate(),$($CPU[0]),$($CPU[1]))"
}
Get-PSSession | where {$_.ComputerName -eq "$xenapp_server"} | Remove-PSSession