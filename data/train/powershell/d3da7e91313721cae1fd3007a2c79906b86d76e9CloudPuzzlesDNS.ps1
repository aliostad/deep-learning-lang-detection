$zone = New-AzureRmDnsZone -Name cloudpuzzles.net -ResourceGroupName cloudpuzzles
$zone = Get-AzureRmDnsZone -Name cloudpuzzles.net -ResourceGroupName cloudpuzzles
Get-AzureRmDnsRecordSet -Name "cloudpuzzles.net" -RecordType NS -Zone $zone

$rs = New-AzureRmDnsRecordSet -Name "@" -RecordType A -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Ipv4Address 94.245.104.73
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "www" -RecordType A -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Ipv4Address 94.245.104.73
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = Get-AzureRmDnsRecordSet -Name awverify -RecordType CNAME -Zone $zone
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname awverify.cloudpuzzles.azurewebsites.net
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "sip" -RecordType CNAME -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname "sipdir.online.lync.com"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "autodiscover" -RecordType CNAME -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname "autodiscover.outlook.com"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "lyncdiscover" -RecordType CNAME -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname "webdir.online.lync.com"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "msoid" -RecordType CNAME -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname "clientconfig.microsoftonline-p.net"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "enterpriseregistration" -RecordType CNAME -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname "enterpriseregistration.windows.net"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "enterpriseenrollment" -RecordType CNAME -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname "enterpriseenrollment.manage.microsoft.com"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "_sip._tls" -RecordType SRV -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Priority 100 -Weight 1 -Port 443 -Target "sipdir.online.lync.com"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "_sipfederationtls._tcp" -RecordType SRV -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Priority 100 -Weight 1 -Port 5061 -Target "sipfed.online.lync.com"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "@" -RecordType MX -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Exchange cloudpuzzles-net.mail.eo.outlook.com -Preference 5
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "@" -RecordType TXT -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Value "v=spf1 include:spf.protection.outlook.com -all"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "tinfoil-site-verification" -RecordType TXT -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Value "6e73af6544da73f12522a4ef2447ac7d04e4cdc7=f2387eb767f370c248d682f8e279050f4d235384"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "test" -RecordType A -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Ipv4Address 40.74.62.167
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "home" -RecordType A -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Ipv4Address 90.184.76.17
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "advania" -RecordType CNAME -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname "site5.webabc.advania.com"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "mail" -RecordType CNAME -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname "outlook.com"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "azure" -RecordType CNAME -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname "portal.azure.com"
Set-AzureRmDnsRecordSet -RecordSet $rs

$rs = New-AzureRmDnsRecordSet -Name "testb" -RecordType CNAME -Zone $zone -Ttl 3600
Add-AzureRmDnsRecordConfig -RecordSet $rs -Cname "outlook.com/cloudpuzzles.net"
Set-AzureRmDnsRecordSet -RecordSet $rs