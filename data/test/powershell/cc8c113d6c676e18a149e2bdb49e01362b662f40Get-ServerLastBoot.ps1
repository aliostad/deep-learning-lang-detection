<#
.Synopsis
   Get-ServerLastBoot - Show last boot time and date for all servers
.DESCRIPTION
   Script searches Active Directory for all 'Server' objects
   Returns csname and lastbootuptime
   Outputs to screen
Long description
.EXAMPLE
   Get-ServerLastBoot
#>

# Find all Servers in Active Directory
$Servers = Get-ADComputer -Filter { OperatingSystem -Like '*Server*' } -Properties OperatingSystem

# Loop through all servers, display last boot time
foreach($Server in $Servers) 
{ 
    Get-CimInstance -ClassName win32_operatingsystem -ComputerName $Server.Name | select csname, lastbootuptime
}
