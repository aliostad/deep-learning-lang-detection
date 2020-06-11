#$webAdminModule = get-module -ListAvailable | ? { $_.Name -eq "webadministration" }
#If ($webAdminModule -ne $null) {
    import-module WebAdministration
#} else {
#    Add-PSSnapin WebAdministration -ErrorAction SilentlyContinue
#}

$websitePath = Join-Path -path $(get-location) -childPath "Restival.Website"

if (Test-Path IIS:\Sites\Restival) {
    $website = Get-Item IIS:\Sites\Restival
} else {
	$website = New-WebSite -Name Restival -Port 80 -HostHeader Restival -PhysicalPath $websitePath
}

Write-Host "Setting website path to $websitePath"
$website.PhysicalPath = $websitePath
$website.ApplicationPool = "ASP.NET v4.0"
$website | set-item

$machineName = $env:computername.ToLower()
# Remove all existing bindings - this is MUCH easier than working out which ones to keep
Get-WebBinding -Name restival | Remove-WebBinding

# restival.<machine-name> - for sandbox deployments accessed via *.machine DNS wildcard
New-WebBinding -Name restival -IPAddress "*" -Port 80 -HostHeader restival.local

$apps = @("Nancy", "WebApi", "OpenRasta", "ServiceStack")
foreach($app in $apps) {
    $iisPath = "IIS:\Sites\Restival\Api.$app"
    $appName = "api.$app".ToLower();
    $scriptPath = split-path $MyInvocation.MyCommand.Definition -parent 
    if (!(Test-Path $iisPath)) { New-WebApplication $appName -Site "restival" -PhysicalPath "$scriptPath\Restival.Api.$app" | out-null }
    Set-ItemProperty $iisPath -name applicationPool -value "ASP.NET v4.0"
    Write-Host "Created application $appName at $scriptPath\Restival.Api.$app"
}