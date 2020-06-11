Clear-Host
$ComputerName = gc env:computername
Get-EventLog -LogName System -ComputerName $ComputerName |
where {$_.EventId -eq 1074} |
ForEach-Object {

    $Syslog = New-Object PSObject | Select-Object Date, User, Action, process, Reason, ReasonCode, Comment, Message
    if ($_.ReplacementStrings[4]) {
        $Syslog.Date = $_.TimeGenerated
        $Syslog.User = $_.ReplacementStrings[6]
        $Syslog.Process = $_.ReplacementStrings[0]
        $Syslog.Action = $_.ReplacementStrings[4]
        $Syslog.Reason = $_.ReplacementStrings[2]
        $Syslog.ReasonCode = $_.ReplacementStrings[3]
        $Syslog.Comment = $_.ReplacementStrings[5]
        $Syslog.Message = $_.Message
        $Syslog
    }
} | Select-Object Date, Action, Comment, User 