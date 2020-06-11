$scriptpath = split-path -parent $MyInvocation.MyCommand.Path
$nugetpath = resolve-path "$scriptpath/../../packages/NuGet.CommandLine.2.8.2/tools/nuget.exe"
$packagespath = resolve-path "$scriptpath/../../dist"
$defaultApiUrl = 'http://packages.nuget.org/v1/'

[string] $apiUrl = Read-Host ("NuGet API Url" + " (or blank for " + $defaultApiUrl + ")")
if([string]::IsNullOrWhitespace($apiUrl)) {
	$apiUrl = $defaultApiUrl
}
[string] $apiKey = Read-Host -Prompt "NuGet API Key"

Write-Host ""

if([string]::IsNullOrWhitespace($apiKey)) {
	Write-Error "An API key is required."
	return;
}
else {
	pushd $packagespath
	try 
	{
		# Find all the packages and display them for confirmation
		$packages = dir "*.nupkg"
		write-host ("Packages to upload to " + $apiUrl + ":")
		$packages | % { write-host $_.Name }

		# Ensure we haven't run this by accident.
		$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Uploads the packages."
		$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Does not upload the packages."
		$options = [System.Management.Automation.Host.ChoiceDescription[]]($no, $yes)

		$result = $host.ui.PromptForChoice("Upload packages", "Do you want to upload the NuGet packages to the NuGet server?", $options, 0) 

		# Cancelled
		if($result -eq 0) {
		"Upload aborted"
		}
		# upload
		elseif($result -eq 1) {
			$packages | % { 
					$package = $_.Name
					write-host "Uploading $package"
					& $nugetpath push -source "$apiUrl" $package $apiKey
					write-host ""
				}
		}
	}
	finally {
		popd
	}
}