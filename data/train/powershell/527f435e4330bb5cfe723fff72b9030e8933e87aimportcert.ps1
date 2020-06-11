# Script to import AdventSTS.pfx and AdventDirectST.pfx keys 
# into local key stores so they can be used by Advent software.
# 
# Author: Bevan Kling, Richard Mills
# Updated: 2015-05-14 Tim Liu

param
(
    [String] $AcdApiPfx = $(throw "Please supply a AdventStsPfx file path"),
    [string] $AcdApiPassword = $(throw "Please supply a StsPassword for STS key")
)

function Import-PfxCertificateSTSmy
{
$certStore = “root”
$certRootStore = “LocalMachine”
$certPath = $AcdApiPfx 
$pfxPass = $AcdApiPassword
$pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2
$pfx.import($certPath,$pfxPass,“Exportable,PersistKeySet”)
$store = new-object System.Security.Cryptography.X509Certificates.X509Store($certStore,$certRootStore)
$store.open(“MaxAllowed”)
$store.add($pfx)
$store.close()
}

$name = [System.IO.Path]::GetFileNameWithoutExtension($AcdApiPfx)

if ((Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object Subject -Match $name).Issuer -eq "")
{
Import-PfxCertificateSTSmy
}
else
{
Write-Host "not import"
}

# PowerShell ./importcert.ps1 C:\Users\tliu\Documents\vQaAcdWs2-1.qa.dx.pfx advs