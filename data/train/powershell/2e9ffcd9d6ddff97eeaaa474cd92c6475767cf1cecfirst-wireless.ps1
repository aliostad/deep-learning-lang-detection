Function Set-OSCHostNetWork
{
<#
	.SYNOPSIS
		The Set-OSCHostNetWork command will start or stop hosted network automatically. 

	.DESCRIPTION
		The Set-OSCHostNetWork command will start or stop hosted network automatically.
		
	.PARAMETER Start
		If this parameter is selected, it will start hosted network automatically.	
	.PARAMETER Stop
		If this parameter is selected, it will stop hosted network automatically.	
		
	.EXAMPLE
		PS C:\> Set-OSCHostNetWork -Start
		
		This command starts hosted network automatically.And if 'start' is not selected, the default is 'start'.
		
	.EXAMPLE
		PS C:\> Set-OSCHostNetWork -Stop
				
		This command stops hosted network automatically.
#>

	[CmdletBinding()]
	param
	(

		[Parameter(Mandatory=$False,Position=0)]
		[String]$Start,
        [Parameter(Mandatory=$False,Position=1)]
        [Switch]$Stop
	
	)
    If(!$Stop)
    {
	
	    If ( (Get-Service -Name "wlansvc"  | select status).status -eq "stopped" )
	    {
		    Write-Warning "The Wlan service is not running.Please turn on wireless and run this script again"
	    }
	    Else
	    {
		    $infors = netsh wlan show  drivers	
		    Foreach($info in $infors)
            { 
                if($info -match "Hosted network supported  : Yes")
                {
                    $Flag =$true 
                }
            }
            $named = 0
            $started = 0
            netsh wlan show hostednetwork | ForEach-Object -Process {
                    if ($_.Contains("SSID") -and $_.Contains("ecfirst-wireless")) {
                        $named = 1
                        }
                    if ($named -eq 1 -and $_.Contains("Status") -and $_.Contains("Started")) {
                        $started = 1
                        }
                    }
            if ($named -eq 1 -and $started -eq 1) {
                Write-Warning "Network already started"
                netsh wlan show hostednetwork
                }
            elseIf($flag)
            {
				$HostName = "ecfirst-wireless"
				$Password =  'P@$sw0rd'
				netsh wlan set hostednetwork mode=allow ssid= $HostName key= $Password  | out-null 
				netsh wlan start hostednetwork | out-null
                $named = 0
                $started = 0
				netsh wlan show hostednetwork | ForEach-Object -Process {
                    if ($_.Contains("SSID") -and $_.Contains("ecfirst-wireless")) {
                        $named = 1
                        }
                    if ($named -eq 1 -and $_.Contains("Status") -and $_.Contains("Started")) {
                        $started = 1
                        }
                    }

                if ($named -eq 1 -and $started -eq 1) {
				    write-host "Created hosted network successfully.`nNetwork name is '$HostName' and password is '$Password' "
					
					$value = "NetWork Name : $Hostname `nPassword : $Password"
					$value | Out-File -FilePath  $env:USERPROFILE"\Desktop\NetWork.txt"
                    netsh wlan show hostednetwork
				}
				Else
				{
				    write-warning "Failed to create hosted network"
				}
            }
            else 
            {
                Write-Warning "Your network adpater do not support Hosted network"
            }
	    }
    }
    Else 
    {
        netsh wlan stop hostednetwork
        netsh wlan show hostednetwork
        Remove-Item $env:USERPROFILE"\Desktop\NetWork.txt"
    }
}

$act = 0
while ($act -ne 1 -and $act -ne 2) {
    $act = Read-Host "Select an action:`n1) Start 'ecfirst-wireless' network`n2) Stop 'ecfirst-wireless' network`n"
    }

switch($act){
    1 {Set-OSCHostNetWork}
    2 {Set-OSCHostNetWork -Stop}
    }