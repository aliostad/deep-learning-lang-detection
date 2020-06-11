param (
	[string]$websiteName,
	[string]$applicationPoolName
)

Write-Verbose "Entering script StartWebApplicationOnTargetMachines.ps1" -Verbose
Write-Verbose "WebsiteName = $websiteName" -Verbose
Write-Verbose "ApplicationPoolName = $applicationPoolName" -Verbose

$websiteName = $websiteName.Trim('"', ' ')
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

# Start the application pool
if(![string]::IsNullOrWhiteSpace($applicationPoolName)) {
	$state = Get-WebAppPoolState -Name $applicationPoolName
	
	if ($state.Value -ne "Started") {
		Write-Output "Starting Application Pool..."
		Start-WebAppPool -Name $applicationPoolName
	} else {
		Write-Output "Application Pool is already started."
	}
}

# Start the website
if(![string]::IsNullOrWhiteSpace($websiteName)) {
	$state = Get-WebsiteState -Name $websiteName
	
	if ($state.Value -ne "Started") {
		Write-Output "Starting website..."
		Start-Website -Name $websiteName
	} else {
		Write-Warning "Website is already started."
	}
}