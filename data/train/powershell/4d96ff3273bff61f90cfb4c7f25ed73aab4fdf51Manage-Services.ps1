function Manage-Services($services) {
	foreach ($config in $services) {
		$service = Get-Service $config.name -ErrorAction SilentlyContinue
		if (-not $service) {
			Write-Verbose "Couldn't find service: $($config.name)" -Verbose
		} else {
			Set-ServiceStartupType $service $config.action
		}
	}
}

function Set-ServiceStartupType($service, $startupType) {
	#$currentStartupType = Get-WmiObject -Query "Select StartMode From Win32_Service Where Name='$($service.name)'"
	#if ($currentStartupType -ne $startupType) {
		Write-Output "Service $($service.name): $startupType"
		Set-Service $service.name -StartupType $startupType
	#}
}