Import-Module WebAdministration

# Stop All App Pools
dir IIS:\AppPools | foreach { $_.Stop() }

# Start All App Pools
dir IIS:\AppPools | foreach { $_.Start() }

# Get All IIS Web Sites
dir IIS:\Sites # or Get-Website

# Remove a Site
Remove-Website -Name WebApp1

# Create new Application Pool
New-WebAppPool -Name FoBa

# Get a single Application Pool
dir IIS:\AppPools | where { $_.Name -eq "FoBa" }

# Get AppPool's certain properties
(dir IIS:\AppPools | where { $_.Name -eq "FoBa" }).managedPipelineMode
(dir IIS:\AppPools | where { $_.Name -eq "FoBa" }).managedRuntimeVersion
(dir IIS:\AppPools | where { $_.Name -eq "FoBa" }).queueLength
(dir IIS:\AppPools | where { $_.Name -eq "FoBa" }).startMode

# Change AppPool Settings
# http://www.iis.net/learn/manage/powershell/powershell-snap-in-making-simple-configuration-changes-to-web-sites-and-application-pools
$foBaAppPool = Get-Item IIS:\AppPools\FoBa
$foBaAppPool.startMode = 1
$fooBarAppPool.queueLength = 5000
$foBaAppPool | Set-Item # call Set-Item at the end of the changes

# New Web Site
New-Website -Name 'WebApp1' -Port 80 -PhysicalPath 'C:\inetpub\wwwroot\WebApp1' -ApplicationPool 'FoBa'

# Stop website
Stop-Website -Name WebApp1