
$path = "C:\Jobs\CloudScale"

Set-Location $path
.\Add-HostNames.ps1 -Hostnames movies-dev.devopsnirvana.com, api.movies-dev.devopsnirvana.com, signalr.movies-dev.devopsnirvana.com -IPAddress 127.0.0.1 -Comment "CloudScale Development"

Write-Output "Creating IIS Website CloudScale.Web"
New-Website -Name CloudScale.Web -HostHeader movies-dev.devopsnirvana.com -PhysicalPath "$path\CloudScale.Web" -Force

Write-Output "Creating IIS Website CloudScale.Api"
New-Website -Name CloudScale.Api -HostHeader api.movies-dev.devopsnirvana.com -PhysicalPath "$path\CloudScale.Api" -Force

Write-Output "Creating IIS Website CloudScale.SignalR"
New-Website -Name CloudScale.SignalR -HostHeader signalr.movies-dev.devopsnirvana.com -PhysicalPath "$path\CloudScale.SignalR" -Force
