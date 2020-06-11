# Function to check windows services related to SQL Server
Function checkservices  ([string] $Hostname )
{
$Services=get-wmiobject -class win32_service -computername $hostname| 
  where {$_.name -like '*SQL*'}| select-object Name,state,status,Started,Startname,Description
foreach ( $service in $Services)
{
	if($service.state -ne "Running" -or  $service.status -ne "OK" -or $service.started -ne "True" )
{
$message="Host="+$Hostname+" " +$Service.Name + 
  " " +$Service.state +" "+$Service.status +" 
  " +$Service.Started +" " +$Service.Startname 
write-host $message -background "RED" -foreground "BLACk"
}
else
{
$message="Host="+$Hostname+" " +$Service.Name +" 
  " +$Service.state +" " +$Service.status +" 
  " +$Service.Started +" " +$Service.Startname 
write-host $message -background "GREEN" -foreground "BLACk"

	}
}
}
