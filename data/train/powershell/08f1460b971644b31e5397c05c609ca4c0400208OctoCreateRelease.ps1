$script:artifactsPath = (property artifactsPath $basePath\artifacts)
$script:prereleaseVersion = (property prereleaseVersion "pre{date}")
$script:releaseNotes = (property releaseNotes "")
$script:releaseNotesFile = (property releaseNotesFile "$artifactsPath\releasenotes.md")
$script:octopusDeployServer = (property octopusDeployServer "")
$script:octopusDeployApiKey = (property octopusDeployApiKey "")
$script:octopusDeployProjectName = (property octopusDeployProjectName $projectName)

task OctoCreateRelease {
	if([String]::IsNullOrEmpty($octopusDeployServer)){
		throw "Please specify the octopusDeployServer"
	}
	if([String]::IsNullOrEmpty($octopusDeployApiKey)){
		throw "Please specify the octopusDeployApiKey"
	}

	$assemblyInfoFile = Get-Content ".\Properties\AssemblyInfo.cs"
	$version = $assemblyInfoFile | 
				where { $_ -match "AssemblyVersion\(`"(?<version>.*)`"\)" } |
				foreach { $matches["version"] }

	$octopusToolsPath = Get-RequiredPackagePath OctopusTools $basePath\$projectName
	$cmd = "$octopusToolsPath\Octo.exe create-release --server=""$octopusDeployServer"" --apiKey=""$octopusDeployApiKey"" --project=""$octopusDeployProjectName"" --version=""$version"""

	if(![String]::IsNullOrEmpty($releaseNotes)){
		$cmd += " --releasenotes=""$releaseNotes"""
	}
	elseif(Test-Path $releaseNotesFile){
		$cmd += " --releasenotesfile=""$releaseNotesFile"""
	}

	exec { & Invoke-Expression $cmd }
}