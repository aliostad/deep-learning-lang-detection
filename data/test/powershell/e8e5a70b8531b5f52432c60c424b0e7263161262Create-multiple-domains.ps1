$ErrorActionPreference = "Stop"
Import-Module "C:\CitrixCamApi\CitrixCamApi.psm1" -Verbose:0 -ea 0
Import-Module "C:\CitrixCamApi\CitrixCamSql.psm1" -Verbose:0 -ea 0

# Edit values below to match your environment
$pwd = ([Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("Citrix123")))

for ($i=4; $i -le 26; $I++)
{
    $privateDomain = New-CreateDomainModel `
    -Name                           "Tenant$i.local" `
    -Type                           "Both" `
    #-OrchestrationServiceUserName   "tenant$i\t$($i)domadmin" `
    -OrchestrationServiceUserName   "tenant$i\xenadmin" `
    -OrchestrationServicePasswordBase64 $pwd
    
    New-domains $privateDomain

    }