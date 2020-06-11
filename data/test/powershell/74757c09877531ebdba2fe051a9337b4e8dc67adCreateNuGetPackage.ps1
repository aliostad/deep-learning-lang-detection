param($apiKey)

function Get-ScriptDirectory 
{ 
 $Invocation = (Get-Variable MyInvocation -Scope 1).Value 
 Split-Path $Invocation.MyCommand.Path 
} 
$scriptDir = Get-ScriptDirectory;
write $scriptDir;

$msbuild = "C:\Program Files (x86)\MSBuild\12.0\bin\MSBuild.exe"
$sln2012 = Join-Path (Get-ScriptDirectory) "..\NewportVS2012.sln"
$sln2013 = Join-Path (Get-ScriptDirectory) "..\NewportVS2013.sln"
$args = @("/m", "/t:Rebuild", "/p:Configuration=Release", "/nologo", "/verbosity:quiet")
& $msbuild $sln2012 $args
& $msbuild $sln2013 $args


# Get Version of Newport.WindowsPhone assembly.
# We will use that as the version of our NuGet package.
$asmPath = Join-Path (Get-ScriptDirectory) "..\Newport.WindowsPhone8\Bin\Release\Newport.WindowsPhone.dll"
write($asmPath);
$version = [System.Reflection.AssemblyName]::GetAssemblyName($asmPath).Version.ToString();
write $version;

# Store version in NuSpec
$nuspecPath = Join-Path (Get-ScriptDirectory) "Newport.nuspec"
write($nuspecPath);
[xml]$nuspec = Get-Content $nuspecPath
$nuspec.package.metadata.version = $version
$nuspec.Save($nuspecPath);

cd $scriptDir;
.\NuGet.exe pack $nuspecPath

#If an API key was specified, upload the package.
if (!$apiKey)
{
  Write-Warning "No ApiKey specified";
  return;
} 

write($apiKey)
.\NuGet.exe SetApiKey $apiKey
.\NuGet.exe push .\Newport.$version.nupkg