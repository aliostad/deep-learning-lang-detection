$citrix_451_servers = @(
    "ENT-APP-CTXP01",
    "ENT-APP-CTXP02",
    "ENT-APP-CTXP03",
    "ENT-APP-CTXP04",
    "ENT-APP-CTXP05",
    "ENT-APP-CTXP06",
    "ENT-APP-CTXP07",
    "ENT-APP-CTXP08",
    "ENT-APP-CTXP09",
    "ENT-APP-CTXV17",
    "ENT-APP-CTXV18",
    "ENT-APP-CTXV19",
    "ENT-APP-CTXV16"
)

function Get-CitrixApplicationsPerServer451 
{
    param(
        [string] $computer
    )

    $apps_on_servers = Get-WmiObject MetaFrame_ApplicationsPublishedOnServer -Namespace "root\citrix" -ComputerName $computer
    $apps = Get-WmiObject MetaFrame_Application -Namespace "root\citrix" -ComputerName $computer | Select Name, DefaultInitProg, EnableApp

    foreach( $app in $apps ) { 
        $app | Add-Member -MemberType NoteProperty -Name Servers -Value ($apps_on_servers | Where { $_.WinApp -imatch $app.Name } | Select @{N="Server";E={($_.CtxServer.Split("=")[1].Replace('"','')) }} | Select -ExpandProperty Server)
    }

    return $apps
}

function Get-CitrixSessions451
{
    param(
        [string[]] $computers
    )

    $processes_by_session = @()
    foreach( $computer in $computers )  {
        $sessions = Get-WmiObject MetaFrame_Session -Namespace "root\citrix" -ComputerName $computer |
                        Where { $_.SessionId -notin (0,65536, 65537)  } | 
                        Select ServerName, SessionId, SessionName, @{N="User";E={$_.SessionUser.Split("=")[1].Split(",")[0]}}, @{N="LastInputTime";E={$_.ConvertToDateTime($_.LastInputTime)}}

        foreach( $session in $sessions ) {
            $proccesses = Get-WmiObject -Query ("SELECT ProcessName, ProcessId FROM MetaFrame_Process where SessionID={0}" -f $session.SessionId) -ComputerName $computer -Namespace root\citrix

            foreach( $proc in $proccesses ) { 
                $processes_by_session += (New-Object -TypeName PSObject -Property @{
                    ServerName = $session.ServerName
                    Session = $session.SessionId
                    SessionName = $session.SessionName
                    User = $session.User
                    LastInput = $session.LastInputTime
                    ProcessName = $proc.ProcessName
                    ProcessId = $proc.ProcessId
                })
            }
        }

    }

    return $processes_by_session  
}


function Get-CitrixLoad451
{
    param(
        [string[]] $computers
    )

    foreach( $computer in $computers )  {
        $server_load = Get-WmiObject MetaFrame_Server_LoadLevel -Namespace "root\citrix" -ComputerName $computer | Select -Expand LoadLevel
        Get-WmiObject MetaFrame_Application_LoadLevel -Namespace "root\citrix" -ComputerName $computer | Select ServerName,  @{N="ServerLoadLevel";E={$server_load}}, AppName, @{N="AppLoadLevel";E={$_.LoadLevel}}
    }
}

function Get-CitrixProcessesInUse451
{
    param(
        [string[]] $computers
    )

    foreach( $computer in $computers )  {
        Get-WmiObject -Query "SELECT * FROM MetaFrame_Process" -ComputerName $computer -Namespace root\citrix | Select ServerName, ProcessId, ProcessName, UserName, SessionId
    }
}