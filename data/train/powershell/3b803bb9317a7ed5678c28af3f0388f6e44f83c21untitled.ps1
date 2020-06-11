# Script to import AdventSTS.pfx and AdventDirectST.pfx keys 
# into local key stores so they can be used by Advent software.
# 
# Author: Bevan Kling, Richard Mills
# Updated: 2015-05-14 Tim Liu

param
(
    [String] $AcdApiPfx = $(throw "Please supply a AdventStsPfx file name"),
    [string] $AcdApiPassword = $(throw "Please supply a StsPassword for STS key")
)

function Import-PfxCertificateSTSmy
{
$certStore = “my”
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

Import-PfxCertificateSTSmy
