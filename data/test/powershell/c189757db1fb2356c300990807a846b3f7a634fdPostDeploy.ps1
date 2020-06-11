$serviceName = "api-boilerplate"
$exePath = Resolve-Path "${WebRootPath}api-boilerplate.Service.exe"
$displayName = "[api-boilerplate] ReST Web Service"

$existingService = Get-WmiObject -Class Win32_Service -Filter "Name='$serviceName'"

if (-Not $existingService) 
{
	. $exePath install -servicename `"$serviceName`" -displayname `"$displayName`" -username `"${ServiceUserName}`" -password `"${ServicePassword}`" --autostart
}

$service = Get-Service $serviceName
$service.Start()
$service.WaitForStatus("Running")