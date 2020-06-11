Function Run-GetGrainsCache {

	Param (
	
		[string]
		[Parameter( Mandatory = $true )]
		$ComputerName,

		[string]
		[Parameter( Mandatory = $true )]
		$CacheName
	)
		
	$ErrorActionPreference = "Stop"
	
	$Grains = $null
	
	$SaltTarget = $ComputerName

	$SaltArguments = "cpu_model,productname,kernelrelease,serialnumber,osrelease,os,virtual"
		
	$CacheURL = "http://$CacheName/api/v2/saltcache/grains/$SaltTarget.spottrading.com/" + $SaltArguments + "?nocase=True"
					
	Try {
		Write-Debug "Getting grains from Salt Cache for $ComputerName..."
		$Grains = Invoke-RestMethod $CacheURL -TimeoutSec 20
	}
	
	Catch { 
		$_ 
		Write-Debug "Got error from Salt Cache..."
		Write-Debug "Trying to get grains from Salt API..."
		$Grains = Run-GetGrains $ComputerName
	}
			
	If ( ! $Grains ) { $Grains = $false }
	
	return $Grains
}