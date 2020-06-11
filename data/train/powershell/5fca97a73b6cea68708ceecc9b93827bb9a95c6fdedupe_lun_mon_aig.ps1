Import-Module DataOntap
$Username  = "admin"
$Password  = ConvertTo-SecureString "Netapp123" -AsPlainText –Force
$clusters = ("am1ntapcdot01","am1ntapcdot02","am1ntapcdot03","am1ntapcdot04","am2ntapcdot05","am1ntapcdot06")
#$Filer  = "10.58.96.222"
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username,$Password
#Connect-NaController $Filer -Credential $cred
Foreach ($Filer in $clusters)
{
#Write-Host $Filer
 Connect-NcController -Name $Filer -Credential $cred
#Get-NcCluster
#Get-NcVol
#Get-NcLun
 Invoke-NcSsh "set -units gb; vol show -fields vserver,volume,size,used,percent-used,dedupe-space-saved-percent -dedupe-space-saved >0"
 Invoke-NcSsh "set -units gb; lun show -fields vserver,path,size,size-used" 
}