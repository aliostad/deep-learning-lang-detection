$msbuild = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe"
$base_directory = Resolve-Path .
$configuration = "Release"
$package = "$base_directory\FileDownloadService.factory.exe"
$apiProject = "$base_directory\CP.Azure.Samples.MultiComponentRole.Api\CP.Azure.Samples.MultiComponentRole.Api.csproj"
$frontEndProject = "$base_directory\CP.Azure.Samples.MultiComponentRole.Frontend\CP.Azure.Samples.MultiComponentRole.Frontend.csproj"
$engineProjectOutput = "$base_directory\CP.Azure.Samples.MultiComponentRole.Engine\bin\$configuration"

$latest_build = "$base_directory\output"
$engineBinaries = "$latest_build\engine"
$apiBinaries = "$latest_build\api"
$frontEndBinaries = "$latest_build\frontend"

$deploy = "$base_directory\deploy"

#############
#### Step 1: Clean up
foreach ($dirToClean in ($latest_build, $deploy)) {
	if (Test-Path $dirToClean) {
		rmdir $dirToClean -recurse -force
	}
}

#############
#### Step 2: Publish project into "output" folder

# Build solution
$allArgs = @("/m", "CP.Azure.Samples.MultiComponentRole.sln", "/p:Configuration=$configuration", "/v:Minimal")
& $msbuild $allArgs

# Publish API
$allArgs = @("$apiProject", "/t:Build", "/v:Minimal", "/p:Configuration=$configuration", "/p:DeployOnBuild=true", "/p:DeployTarget=Package", "/p:_PackageTempDir=`"$apiBinaries`"")
& $msbuild $allArgs

# Publish Frontend
$allArgs = @("$frontEndProject", "/t:Build", "/v:Minimal", "/p:Configuration=$configuration", "/p:DeployOnBuild=true", "/p:DeployTarget=Package", "/p:_PackageTempDir=`"$frontEndBinaries`"")
& $msbuild $allArgs

# Publish Engine
md -Path "$engineBinaries"
copy -Path "$engineProjectOutput\*" -recurse -destination "$engineBinaries\" -Force

##############
#### Step 3: Create a package ready for Azure deployment

# Open package
if (Test-Path $package) {
	$allArgs = @("-unpack", "-target=`"$deploy`"")
	& $package $allArgs
}

# Locate paths of sites and services
$engineTarget = (Get-ChildItem -Path $deploy -Filter ProcessingEngine.txt -Recurse).DirectoryName
$webApiTarget = (Get-ChildItem -Path $deploy -Filter WebApi.txt -Recurse).DirectoryName
$frontendTarget = (Get-ChildItem -Path $deploy -Filter Frontend.txt -Recurse).DirectoryName

# Inject "Api"
if ($webApiTarget -and (Test-Path $webApiTarget)) {
	Remove-Item "$webApiTarget\*" -Recurse
	Copy-Item "$apiBinaries\*" "$webApiTarget\" -recurse
}
# Inject "Frontend"
if ($frontendTarget -and (Test-Path $frontendTarget)) {
	Remove-Item "$frontendTarget\*" -Recurse
	Copy-Item "$frontEndBinaries\*" "$frontendTarget\" -recurse
}
# Inject "Engine"
if ($engineTarget -and (Test-Path $engineTarget)) {
	Remove-Item "$engineTarget\*" -Recurse
	Copy-Item "$engineBinaries\*" "$engineTarget\" -recurse
}

# Produce Azure package
if (Test-Path $package) {
	$allArgs = @("-repack", "-target=`"$deploy`"")
	& $package $allArgs
}
