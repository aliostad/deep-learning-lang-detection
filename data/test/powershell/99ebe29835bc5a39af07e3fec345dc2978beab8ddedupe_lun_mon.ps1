Import-Module DataOntap
$Username  = "ive860"
$Password  = ConvertTo-SecureString "Nm,.7890" -AsPlainText –Force
$clusters = ("pdcnetappbkp01","kdcnetappbkp01","kdcnetapp02","kdcnetappsas01")
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
 Invoke-NcSsh "set -units gb; vol show -fields vserver,volume,size,used,percent-used,dedupe-space-saved,dedupe-space-shared,dedupe-space-saved-percent -dedupe-space-saved >0"
 Invoke-NcSsh "set -units gb; lun show -fields vserver,path,size,size-used"
}