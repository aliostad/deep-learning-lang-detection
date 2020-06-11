param (
	[string]$webSiteName,
	[string]$applicationPoolName
)

Write-Verbose "Entering script StopWebApplicationOnTargetMachines.ps1" -Verbose
Write-Verbose "WebsiteName = $websiteName" -Verbose
Write-Verbose "ApplicationPoolName = $applicationPoolName" -Verbose

$webSiteName = $webSiteName.Trim('"', ' ')
$applicationPoolName = $applicationPoolName.Trim('"', ' ')

function Import-WebAdministration {
	$ModuleName = "WebAdministration"
	$ModuleLoaded = $false
	$LoadAsSnapin = $false

	if ($PSVersionTable.PSVersion.Major -ge 2) {
		if ((Get-Module -ListAvailable | ForEach-Object {$_.Name}) -contains $ModuleName) {
			Import-Module $ModuleName

			if ((Get-Module | ForEach-Object {$_.Name}) -contains $ModuleName) {
				$ModuleLoaded = $true
			} else {
				$LoadAsSnapin = $true
			}
		} elseif ((Get-Module | ForEach-Object {$_.Name}) -contains $ModuleName) {
			$ModuleLoaded = $true
		} else {
			$LoadAsSnapin = $true
		}
	} else {
		$LoadAsSnapin = $true
	}
	
	if ($LoadAsSnapin) {
		try {
			if ((Get-PSSnapin -Registered | ForEach-Object {$_.Name}) -contains $ModuleName) {
				if ((Get-PSSnapin -Name $ModuleName -ErrorAction SilentlyContinue) -eq $null) {
					Add-PSSnapin $ModuleName
				}

				if ((Get-PSSnapin | ForEach-Object {$_.Name}) -contains $ModuleName) {
					$ModuleLoaded = $true
				}
			} elseif ((Get-PSSnapin | ForEach-Object {$_.Name}) -contains $ModuleName) {
				$ModuleLoaded = $true
			}
		} catch {
			Write-Error "`t`t$($MyInvocation.InvocationName): $_"
			Exit
		}
	}
}

Import-WebAdministration

# Stop the website
if(![string]::IsNullOrWhiteSpace($webSiteName)) {
	try {
		$state = Get-WebSiteState -Name $webSiteName
		
		if ($state.Value -ne "Stopped") {
			Write-Output "Stopping website..."
			Stop-WebSite -Name $webSiteName
		} else {
			Write-Output "Website is already stopped."
		}
	}
	catch [System.Management.Automation.ItemNotFoundException] {
		Write-Output "Website does not exist."
	}
}

# Stop the application pool
if(![string]::IsNullOrWhiteSpace($applicationPoolName)) {
	try {
		$state = Get-WebAppPoolState -Name $applicationPoolName
		
		if ($state.Value -ne "Stopped") {
			Write-Output "Stopping Application Pool..."
			Stop-WebAppPool -Name $applicationPoolName
		} else {
			Write-Output "Application Pool is already stopped."
		}
	}
	catch [System.Management.Automation.ItemNotFoundException] {
		Write-Output "Application Pool does not exist."
	}
}