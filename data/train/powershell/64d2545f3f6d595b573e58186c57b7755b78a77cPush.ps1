$script:artifactsPath = (property artifactsPath $basePath\artifacts)
$script:nugetPackageSource = (property nugetPackageSource "")
$script:nugetPackageSourceApiKey = (property nugetPackageSourceApiKey "LoadFromNuGetConfig")
$script:nugetSymbolsPackageSource = (property nugetSymbolsPackageSource "")
$script:nugetSymbolsPackageSourceApiKey = (property nugetSymbolsPackageSourceApiKey "LoadFromNuGetConfig")
$script:ignoreNugetPushErrors = (property ignoreNugetPushErrors "") # Semicolon-delimited string of known error messages to ignore

task Push {	
	$packages = @(Get-ChildItem $artifactsPath\*.nupkg)
	if ($packages.Count -eq 0) {
		"No packages were found in $artifactsPath. Please build some packages first."
	}
	else {
		"Pushing the following packages:"
		$packages | Select -ExpandProperty Name | Write-Host
		
		if (!$nugetPackageSource) {
			$nugetPackageSource = Read-Host "Please enter NuGet package source"
		}
		$packageSourceIsHttp = $nugetPackageSource.ToLower().StartsWith("http")
		if (!$nugetPackageSourceApiKey -and $packageSourceIsHttp) {
			$nugetPackageSourceApiKey = Read-Host "Please enter NuGet package source API key"
		}
		
		# NuGet.exe automatically pushes symbols package to http://nuget.gw.symbolsource.org/Public/NuGet when pushing main package to https://www.nuget.org
		if (!$nugetPackageSource.StartsWith("https://www.nuget.org") -and @($packages | Where-Object { $_.Name.EndsWith("symbols.nupkg") }).Count -gt 0) {
			if (!$nugetSymbolsPackageSource) {
				$nugetSymbolsPackageSource = Read-Host "Please enter NuGet symbols package source"
			}
			if ($nugetSymbolsPackageSource) { # A symbols package source is optional
				$symbolsPackageSourceIsHttp = $nugetSymbolsPackageSource.ToLower().StartsWith("http")
				if (!$nugetSymbolsPackageSourceApiKey -and $packageSourceIsHttp) {
					$nugetSymbolsPackageSourceApiKey = Read-Host "Please enter NuGet symbols package source API key"
				}
			}
		}
		else {
			$nugetSymbolsPackageSource = $null
		}
		
		foreach($package in $packages) {
			if ($package.Name.EndsWith("symbols.nupkg") -and $nugetSymbolsPackageSource) {
				Push-Package $basePath $package $nugetSymbolsPackageSource $nugetSymbolsPackageSourceApiKey $ignoreNugetPushErrors
			}
			else {
				Push-Package $basePath $package $nugetPackageSource $nugetPackageSourceApiKey $ignoreNugetPushErrors
			}
		}
	}
}