#List default Providers
Clear-Host
Get-PSProvider

Clear-Host
Get-PSDrive

# Move to the ENV drive
Clear-Host
Set-Location env:
Get-ChildItem

Clear-Host
Get-ChildItem | Format-Table -Property Name, Value -AutoSize
  
Clear-Host
Set-Location alias:
Get-ChildItem



# Adding a new provider --------------------------------------------------------------------

# Show list of snap-ins
Clear-Host
Get-PSSnapin

# Show list of registered snap-ins
Clear-Host
Get-PSSnapin -Registered

# Load the SQL Server add-ins
Clear-Host
Add-PSSnapin SqlServerCmdletSnapin100
Add-PSSnapin SqlServerProviderSnapin100

# Validate they are loaded
Clear-Host
Get-PSSnapin -Name "Sql*"

# Show SQLServer now added to the list of drives
Get-PSDrive

Clear-Host
Set-Location SQLSERVER:
Get-ChildItem
Get-ChildItem | Select-Object PSChildName

# Change the location to the sql root to show the list of servers
Clear-Host
Set-Location SQL
Get-ChildItem

# Change to the server and show the list of instances
Clear-Host
Set-Location FL-WS-CON-RC01
Get-ChildItem | Select-Object PSChildName

# Change to the default Instance
Clear-Host
Set-Location DEFAULT
Get-ChildItem

# Change to the list of Databases
Clear-Host
Set-Location Databases
Get-ChildItem | Select-Object PSChildName

# Change to the a database
Clear-Host
Set-Location AdventureWorksLT2008R2
Get-ChildItem | Select-Object PSChildName

#Change to the object "Tables"
Clear-Host
Set-Location Tables
Get-ChildItem | Select-Object PSChildName

# Unload the snapin 
Clear-Host
Remove-PSSnapin SqlServerCmdletSnapin100
Remove-PSSnapin SqlServerProviderSnapin100

# Validate they are loaded
Clear-Host
Get-PSSnapin | Select-Object Name
Get-PSProvider
##
