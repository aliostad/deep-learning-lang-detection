Import-Module "C:\Program Files\Citrix\CloudAppManagement\InfrastructureTools\InfrastructureTools.psm1" -Verbose:0 -ea 0
for ($i=3; $i -le 25; $i++)
{
   # $secpasswd = ConvertTo-SecureString "Citrix123" -AsPlainText -Force

   # $SFdbcred = New-Object System.Management.Automation.PSCredential ("Tenant$i\tenant$($i)admin", $secpasswd)

   # $SFadmincred = New-Object System.Management.Automation.PSCredential ("Tenant$i\T$($i)SFadmin", $secpasswd)

   $j=($i*2)
   $suffix = $j.tostring("00")
    $k=($j-1).tostring("00")

    switch ($i % 5)
    {
        1 {New-CamStoreFrontServerGroup -Name "Tenant$($i)-SF" -Servers @("Carina-SF$($k)", "Carina-SF$($suffix)") -CertificateFriendlyName "wildcard" -LoadBalancerUrl "https://Carina-SF$($k).carina.local"  -DatacenterName carina-31-east -DomainName carina.local -NetworkName Tenant$i  -Verbose}
        2 {New-CamStoreFrontServerGroup -Name "Tenant$($i)-SF" -Servers @("Carina-SF$($k)", "Carina-SF$($suffix)") -CertificateFriendlyName "wildcard" -LoadBalancerUrl "https://Carina-SF$($k).carina.local"  -DatacenterName carina-31-west -DomainName carina.local -NetworkName Tenant$i  -Verbose}
        3 {New-CamStoreFrontServerGroup -Name "Tenant$($i)-SF" -Servers @("Carina-SF$($k)", "Carina-SF$($suffix)") -CertificateFriendlyName "wildcard" -LoadBalancerUrl "https://Carina-SF$($k).carina.local"  -DatacenterName carina-31-north -DomainName carina.local -NetworkName Tenant$i  -Verbose}
        4 {New-CamStoreFrontServerGroup -Name "Tenant$($i)-SF" -Servers @("Carina-SF$($k)", "Carina-SF$($suffix)") -CertificateFriendlyName "wildcard" -LoadBalancerUrl "https://Carina-SF$($k).carina.local"  -DatacenterName carina-31-south -DomainName carina.local -NetworkName Tenant$i  -Verbose}
        0 {New-CamStoreFrontServerGroup -Name "Tenant$($i)-SF" -Servers @("Carina-SF$($k)", "Carina-SF$($suffix)") -CertificateFriendlyName "wildcard" -LoadBalancerUrl "https://Carina-SF$($k).carina.local"  -DatacenterName carina-31-middle -DomainName carina.local -NetworkName Tenant$i  -Verbose}
             
       
       } 
      Start-Sleep 180
    }