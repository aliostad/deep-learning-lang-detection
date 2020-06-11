$id = "CSharpVitamins.XmlDocumentation.Compatibility"
$folder = "$id"
$nuspec = ".\$folder\$id.nuspec"
$csproj = ".\$folder\$id.csproj"
$dllPath = ".\$folder\bin\Release\xmldoc-markdown-compat.exe"
$packaged = $false
$pushed = $false

$dllVersion = ([System.Version](Get-Command $dllPath).FileVersionInfo.ProductVersion).ToString(3)

md .\build -force

Write-Host "Packaging" -ForegroundColor Cyan
Write-Host " > $nuspec"
Write-Host " > $dllVersion"
Write-Host ""
Write-Host "Please enter package version, or leave blank to use [$($dllVersion)]..."

$semver = Read-Host "SemVer"
if (!$semver) {

	$semver = $dllVersion

}

if ($semver) {

	Write-Host ""
	Write-Host "nuget pack '$semver'..."

	& nuget pack $csproj -version $semver -prop Configuration=Release -verbosity detailed -symbol -outputdirectory .\build

	if ($?) {
		$packaged = $true;
		Write-Host "packed okay" -ForegroundColor Green
	} else {
		Write-Host "pack failed" -ForegroundColor Red
	}

}

if ($packaged) {

	Write-Host ""
	Write-Host "Push?" -ForegroundColor Cyan

	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Push'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Skip'))

	$decision = $Host.UI.PromptForChoice("Push?", "Do you want to push '$semver' to nuget?", $choices, 1)
	if ($decision -eq 0) {

		if (!$api_key) {
			$api_key = Read-Host "API Key"
		}

		Write-Host "pushing '$semver' to nuget..."

		if ($api_key) {
			& nuget push .\build\$id.$semver.*.nupkg -apikey $api_key
		} else {
			& nuget push .\build\$id.$semver.*.nupkg
		}

		if ($?) {

			$pushed = $true
			Write-Host "pushed okay" -ForegroundColor Green

		} else {
			Write-Host "push failed" -ForegroundColor Red
		}

	} else {
		Write-Host "skipping"
	}

}

Write-Host "finito!"
