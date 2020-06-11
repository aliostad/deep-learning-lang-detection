<#
.SYNOPSIS
Takes a list of servers and returns the session information for them

.PARAMETER servers
A list of servers to check

.PARAMETER showAllSessions
If not specified, only sessions with usernames will be listted
#>

param (
    [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
    [string[]] $servers,
    [switch] $showAllSessions
)

begin {
    $report = @()
}
process {

    foreach ($server in $servers) {
        $sessions = query session /server:$server

        foreach ($i in 1..($sessions.count -1)) {
            $temp = "" | Select-Object Server, SessionName, Username, Id, State, Type, Device
            $temp.Server = $server
            $temp.SessionName = $sessions[$i].Substring(1,18).Trim()
            $temp.Username = $sessions[$i].Substring(19,20).Trim()
            $temp.Id = $sessions[$i].Substring(39,9).Trim()
            $temp.State = $sessions[$i].Substring(48,8).Trim()
            $temp.Type = $sessions[$i].Substring(56,12).Trim()
            $temp.Device = $sessions[$i].Substring(68).Trim()
            $report += $temp
        }
    }
}

end {
    if ($showAllSessions.IsPresent) {
        $report
    }
    else {
        $report |? {$_.Username}
    }
}
