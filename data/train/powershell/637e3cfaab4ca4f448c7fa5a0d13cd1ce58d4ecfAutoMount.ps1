<#
脚本主要用于对Networker的adv_file进行自动mount操作。在Networker服务器上设置将等待媒体的日志记录至eventlog，使用脚本每隔10分钟检查一次日志，发现需要mount的，则进行mount操作。
#>

Get-EventLog -LogName application -Source Networker -Message "NetWorker media:*Waiting for*" -after ((Get-Date).AddMinutes(-10))|Select-Object Message|Export-Csv EventLogMessage.csv -Encoding UTF8

$EventLogMessage = Import-csv EventLogMessage.csv
$adv_file_list = Import-csv adv_file_list.csv

Foreach($i in $EventLogMessage){
    ForEach($j in $adv_file_list){
        If ($i.Message.split(" ")[11].replace("'","") -eq $j.pool -and $i.Message.split(" ")[14].replace("`r`n","").ToLower() -eq $j.node.ToLower()){
            Write-Host $j.name
            nsrmm -m -f $j.name
        }
    }
}