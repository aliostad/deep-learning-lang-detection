$base = (Get-Item ..).FullName
$lib = Join-Path $base 'lib'
$pkg = Join-Path $base 'pkg'
$out = Join-Path $base 'out'

$nuget = "$lib\NuGet.CommandLine.*\tools\NuGet.exe"

Task Default -depends Publish

Task Publish -depends Initialize-Directories, Create-NuGetPackages

Task Initialize-Directories {
  if(Test-Path $out) {
    Remove-Item -Recurse -Force $out
  }
  
  New-Item $out -Type directory  
}

Task Create-NuGetPackages {
  Push-Location $out
  
  Get-ChildItem $pkg -Recurse -Filter *.nuspec | ForEach {
    $spec = $_.FullName
    Exec { Invoke-Expression "$nuget pack $spec" }
  }
  
  Pop-Location
}

Task Push-Packages {  
  $apiKey = '';
  $apiKeyConfigured = $false
  
  # Is API key passed as an argument?
  if($args.Length -eq 1)
  {
    $apiKey = $args[0]
	$apiKeyConfigured = $true;
  }
  
  # Check NuGet.config for API key.
  if($apiKeyConfigured -eq $false)
  {
    $path = "$env:APPDATA\NuGet\NuGet.config"
    [xml] $xml = Get-Content $path
  
    foreach($key in $xml.configuration.apikeys) {
	
      if ($key.add.key -eq "https://www.nuget.org") {
        $apiKeyConfigured = $true
	    break
      }
    }
  }
  
  # Prompt user to enter API key.
  if($apiKeyConfigured -eq $false)
  {
    Write-Host 'API key: ' -NoNewline
    $apiKey = Read-Host
  }

  Get-ChildItem $out -Filter *.nupkg | ForEach {
    try
	  {
  	  $pkg = $_.FullName
	  
	    if($apiKey.Length -eq 0)
	    {
        Exec { Invoke-Expression "$nuget push $pkg" }
      }
      else
      {
        Exec { Invoke-Expression "$nuget push $pkg $apiKey" }
      }
    }
    catch { }
  }
}