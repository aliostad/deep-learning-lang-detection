<#
This script allows for recycling an app pool within IIS.
It uses ADSI to load up an app pool.
#>
function Invoke-AppPoolRecycle(
	[string] $machineName = "localhost",
	[string] $poolName = $(Throw "Please specify an app pool name")
) {
    try {
		$pool = [adsi]"IIS://$machineName/w3svc/apppools/$poolName"
		$pool.Recycle()
	} catch [System.Management.Automation.ExtendedTypeSystemException] {
		"Could not load app pool '$poolName' on '$machineName'"
	}
}

New-Alias -Name iapr -value Invoke-AppPoolRecycle -Description "Recycle an app pool"

Export-ModuleMember -alias * -function *
