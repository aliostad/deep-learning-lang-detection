Import-Module "C:\Program Files\Citrix\CloudAppManagement\InfrastructureTools\InfrastructureTools.psm1" -Verbose:0 -ea 0
for ($i=2; $i -le 26; $i++)
{
   # $secpasswd = ConvertTo-SecureString "Citrix123" -AsPlainText -Force

   # $SFdbcred = New-Object System.Management.Automation.PSCredential ("Tenant$i\tenant$($i)admin", $secpasswd)

   # $SFadmincred = New-Object System.Management.Automation.PSCredential ("Tenant$i\T$($i)SFadmin", $secpasswd)

    switch ($i % 5)
    {
        1 {New-CamStoreFrontServerGroup -Name "Tenant$($i)-SF" -Servers "Tenant$i-SF1", "Tenant$i-SF2" -CertificateFriendlyName "wildcard" -LoadBalancerUrl "https://tenant$($i)-sf1.tenant$($i).local"  -DatacenterName carina23-west -DomainName Tenant$($i).local -NetworkName Tenant$i  -Verbose}
        2 {New-CamStoreFrontServerGroup -Name "Tenant$($i)-SF" -Servers "Tenant$i-SF1", "Tenant$i-SF2" -CertificateFriendlyName "wildcard" -LoadBalancerUrl "https://tenant$($i)-sf1.tenant$($i).local"  -DatacenterName carina23-east -DomainName Tenant$($i).local -NetworkName Tenant$i  -Verbose}
        3 {New-CamStoreFrontServerGroup -Name "Tenant$($i)-SF" -Servers "Tenant$i-SF1", "Tenant$i-SF2" -CertificateFriendlyName "wildcard" -LoadBalancerUrl "https://tenant$($i)-sf1.tenant$($i).local"  -DatacenterName carina23-north -DomainName Tenant$($i).local -NetworkName Tenant$i  -Verbose}
        4 {New-CamStoreFrontServerGroup -Name "Tenant$($i)-SF" -Servers "Tenant$i-SF1", "Tenant$i-SF2" -CertificateFriendlyName "wildcard" -LoadBalancerUrl "https://tenant$($i)-sf1.tenant$($i).local"  -DatacenterName carina23-south -DomainName Tenant$($i).local -NetworkName Tenant$i  -Verbose}
        0 {New-CamStoreFrontServerGroup -Name "Tenant$($i)-SF" -Servers "Tenant$i-SF1", "Tenant$i-SF2" -CertificateFriendlyName "wildcard" -LoadBalancerUrl "https://tenant$($i)-sf1.tenant$($i).local"  -DatacenterName carina23-middle -DomainName Tenant$($i).local -NetworkName Tenant$i  -Verbose}
             
       
       } 
    }