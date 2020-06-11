param($apiKey)

function Get-ScriptDirectory 
{ 
 $Invocation = (Get-Variable MyInvocation -Scope 1).Value 
 Split-Path $Invocation.MyCommand.Path 
} 
$scriptDir = Get-ScriptDirectory;
write $scriptDir;

$msbuild = "C:\Program Files (x86)\MSBuild\14.0\bin\MSBuild.exe"
$sln = Join-Path (Get-ScriptDirectory) "..\DotNeuralNet\DotNeuralNet.sln"
$args = @("/m", "/t:Rebuild", "/p:Configuration=Release", "/nologo", "/verbosity:quiet")
& $msbuild $sln $args

# Get Version of assembly.
# We will use that as the version of our NuGet package.
$asmPath = Join-Path (Get-ScriptDirectory) "..\DotNeuralNet\Bin\Release\DotNeuralNet.dll"
write($asmPath);
$version = [System.Reflection.AssemblyName]::GetAssemblyName($asmPath).Version.ToString();
write $version;

# Store version in NuSpec
$nuspecPath = Join-Path (Get-ScriptDirectory) "DotNeuralNet.nuspec"
write($nuspecPath);
[xml]$nuspec = Get-Content $nuspecPath
$nuspec.package.metadata.version = $version
$nuspec.Save($nuspecPath);

cd $scriptDir;
NuGet.exe pack $nuspecPath

#If an API key was specified, upload the package.
if (!$apiKey)
{
  Write-Warning "No ApiKey specified";
  return;
} 

write($apiKey)
NuGet.exe SetApiKey $apiKey
NuGet.exe push .\DotNeuralNet.$version.nupkg