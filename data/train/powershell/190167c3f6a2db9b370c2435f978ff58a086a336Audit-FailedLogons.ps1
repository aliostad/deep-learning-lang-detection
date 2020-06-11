<#
This will check event logs on Windows Server 2008 and
up for the following criteria:
2 or more failed logon attemps from the same source
IP address, with different usernames and within a
1 minute window.
#>


$path = Split-Path (get-winevent -ListLog security).LogFilePath | %{$_ -replace "%systemroot%",$env:systemroot}
#$path = "c:\directory_with_evtx_log_files\"

$logs = get-childitem $path -filter *security*
$dbEvents = $logs | %{Get-WinEvent -FilterHashtable @{id=4625; path=$_.fullname;} -erroraction silentlycontinue  | ?{$_.message -like "*Unknown user name or bad password.*"}} | sort timecreated -descending

$groups = $dbevents | group {$_.message.split("`n")[25].split("`t")[2]}

$logs = foreach($group in $groups) {
    for ($i=0; $i -lt $group.group.count-1; $i++) {
        if(((($group.group[$i].timecreated - $group.group[$i+1].timecreated).totalminutes) -le 1) -and ($group.group[$i].message.split("`n")[12].split("`t")[3] -ne $group.group[$i+1].message.split("`n")[12].split("`t")[3])) {
            $group.group[$i]
            $group.group[$i+1]
        }
    }
}

if(!(test-path c:\temp)) {New-Item c:\temp -type directory}

$logs | sort recordid -unique | sort timecreated, {$_.message.split("`n")[25].split("`t")[2]} | export-clixml ("c:\temp\0827investigation-" + (hostname) + ".xml")
