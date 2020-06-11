#Notes
#https://blogs.technet.com/b/jamesone/archive/2009/02/18/how-to-manage-the-windows-firewall-settings-with-powershell.aspx?Redirected=true
#https://blogs.msdn.com/b/tomholl/archive/2010/11/08/adding-a-windows-firewall-rule-using-powershell.aspx?Redirected=true


#Variables
[bool] $DNS = True

#Services List
$services_stop = @("BITS", "Dhcp", "RemoteRegistry", "WwanSvc", "WSearch", "TrustedInstaller", "Themes", "Schedule")
$services_start = @("")
#Stop Services
foreach($service in $services_stop) {
    Stop-Service -Name $service
}
#Start Services
foreach($service in $services_stop) {
    Start-Service -Name $service
}
#Possible Inject - Block timewasters
if($DNS) {

}