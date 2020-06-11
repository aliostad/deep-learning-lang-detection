# Returns users logged into globalprotect over the last 7 days

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$True,Position=0)]
	[string]$Device,
    
    [Parameter(Mandatory=$True,Position=1)]
	[string]$ApiKey
)

$Connect = Get-PaDevice $Device -apikey $ApiKey


$Now       = Get-Date
$Date      = get-date $now.AddDays(-7) -format "yyyy/MM/dd HH:mm:ss"
$Query     = "(( eventid eq globalprotectgateway-auth-succ ) and ( receive_time geq '$Date' ))" 
$LogJob    = Get-PaLog -LogType system -Query $Query -WaitForJob

$UsernameRx = [regex] "User\ name:\ ([^\,]+?),"
$Users = @()
foreach ($Entry in $Logjob.log.logs.entry) {
    $UsernameMatch = $UsernameRx.Match($Entry.opaque)
    if ($UsernameMatch.Success) {
        $Users += $UsernameMatch.Groups[1].Value
    }
}

return $Users | Select -unique