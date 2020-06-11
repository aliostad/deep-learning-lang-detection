param(
    $SmtpTo,
    $SmtpFrom,
    $SmtpServer
)

Import-Module (Join-Path $env:POWERSHELL_HOME "\Libraries\Sharepoint_Functions.ps1")
Import-Module (Join-Path $env:POWERSHELL_HOME "\Libraries\General_Variables.psm1")

$XAServer = $citrix_environment.Farm01.DATA_COLLECTOR
$SharePointUrl = $deployment_tracking.IssueTracker.Url
$SharePointList = $deployment_tracking.IssueTracker.List

$ActiveServers = Invoke-Command -ComputerName $XAServer -ScriptBlock{
    Add-PSSnapin Citrix.XenApp.Commands
	$Results = Get-XAServerLoad | Sort ServerName
	return $Results | Select ServerName
}

$XAServerList = Invoke-Command -ComputerName $XAServer -ScriptBlock{
	Add-PSSnapin Citrix.XenApp.Commands
    $Results = Get-XAServer | Sort ServerName 
    return $Results | Select ServerName
}

$Compare = Compare-Object $XAServerList.ServerName $ActiveServers.ServerName

if($Compare)
{
    foreach($ServerName in $Compare.InputObject.ServerName)
    {
        $Service = Get-Service -Name ImaService -ComputerName $ServerName | Restart-Service -Force
        Write-Verbose "$ServerName was not found active in the server load object. Restarting ImaService to resolve!"
        $Table = @{
            Title = "$ServerName : XenApp Server Unavailable"
            User = $env:USERNAME
            Description = "$ServerName was not found active in the server load object. Restart-Service -Name ImaService cmdlet performed on $ServerName to resolve."
        }
        WriteTo-SPListViaWebService -url $SharePointUrl -list $SharePointList -Item $Table

        Start-Sleep -Seconds 3
        $FarmLoad = Invoke-Command -ComputerName $ServerName -ScriptBlock {qfarm /load}

        $EmailParams = @{
            To = $SmtpTo
            From = $SmtpFrom
            SmtpServer = $SmtpServer
            Subject = "$ServerName Unavailable - ImaService Restarted!"
            Body = "The Check-XenAppServerAvailability process has detected that $ServerName was not listed in the active servers in the XenApp farm. 
            Restart-Service -Name ImaService cmdlet has been performed on $ServerName to resolve the issue. Please verify the server re-connects to the farm properly.
            
            $FarmLoad
            "
            Priority = "High"
        }
        Send-MailMessage @EmailParams
    }
}
else
{
    Write-Verbose "All servers are active and in the server load object. No action taken."
}