. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'common.ps1')

$urlx86 = 'http://octopusdeploy.com/downloads/latest/OctopusTentacle'
$urlx64 = 'http://octopusdeploy.com/downloads/latest/OctopusTentacle64'

$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""

$arguments = Parse-Arguments $customArgs

$result | Out-String | Write-Host

Install-ChocolateyPackage 'OctopusTentacle' 'msi' '/q' $urlx86 $urlx64

Write-Output "Configuring and registering Tentacle"
   
$instanceName = $arguments.InstanceName
cd "${env:ProgramFiles}\Octopus Deploy\Tentacle"

& .\tentacle.exe create-instance --instance $instanceName --config "${env:SystemDrive}\Octopus\Tentacle\Tentacle.config" --console
& .\tentacle.exe new-certificate --instance $instanceName --console
& .\tentacle.exe configure --instance $instanceName --home "${env:SystemDrive}\Octopus" --console
& .\tentacle.exe configure --instance $instanceName --app "${env:SystemDrive}\Octopus\Applications" --console
  
if($arguments.Port) {
      & .\tentacle.exe configure --instance $instanceName --port $arguments.Port --console
}
else { 
    Write-Output "Port not specified"
}

if($arguments.Thumbprint) {
  & .\tentacle.exe configure --instance $instanceName --trust $arguments.Thumbprint --console 
}
else { 
    Write-Output "Thumbprint not specified"
}

if($arguments.OctopusUrl -and $arguments.apiKey -and $arguments.Role -and $arguments.Environment) {
  $requestType = "http"
  if($arguments.UseSSL) {
    $requestType = ($requestType + 's')
  }
  Write-Host "ApiKey: " $arguments.ApiKey
  & .\Tentacle.exe register-with --instance $instanceName --server ($RequestType + '://' + $arguments.OctopusUrl) --apiKey $arguments.ApiKey --role $arguments.Role --environment  $arguments.Environment --comms-style TentaclePassive --console
}
else { 
    Write-Output "Octopus URL, api key, role or environment not specified"
}
  
  Write-Output "Starting the 2.0 Tentacle"
  & .\tentacle.exe service --instance $instanceName --install --start --console
  
  Write-Output "Tentacle commands complete"
