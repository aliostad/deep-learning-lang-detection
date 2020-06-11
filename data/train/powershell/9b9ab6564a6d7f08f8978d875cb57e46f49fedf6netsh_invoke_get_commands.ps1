get-vm -Name vmname | %{
$_.Name; $_ | Invoke-VMScript -GuestUser "test" -GuestPassword "test" -ScriptType Bat -ScriptText "netsh interface ipv4 show addresses" -HostUser "test1" -hostpassword "test1"
$_.Name; $_ | Invoke-VMScript -GuestUser "test" -GuestPassword "test" -ScriptType Bat -ScriptText "netsh interface ipv4 show dnsservers" -HostUser "test1" -hostpassword "test1"
$_.Name; $_ | Invoke-VMScript -GuestUser "test" -GuestPassword "test" -ScriptType Bat -ScriptText "netsh interface ipv4 show winsservers" -HostUser "test1" -hostpassword "test1"
} 

<#

#netsh interface ip set address name="Local Area Connection" static 123.123.123.123 255.255.255.0 123.123.123.1 1
#1 is the gateway metric. You can leave this as 1 for almost all cases.  
For the primary DNS run:

netsh interface ip set dns name="Local Area Connection" static 208.67.222.222

For the secondary run:

netsh interface ip add dns name="Local Area Connection" 208.67.220.220 index=2

#>


netsh -c interface dump &gt; c:\location1.txt
netsh -c interface dump &gt; c:\location2.txt
netsh -f c:\location1.txt
netsh exec c:\location2.txt


netsh interface ip set dns "Local Area Connection" static 192.168.0.200
netsh interface ip set wins "Local Area Connection" static 192.168.0.200


netsh interface ipv4 show interfaces
netsh interface ipv4 show address 14

netsh interface ipv4 set address “Local Area Connection” static 192.168.1.2 255.255.255.0 192.168.1.1 1
netsh interface ip add address "Local Area Connection" 33.33.33.33 255.255.255.255

netsh interface ipv4 add address “Local Area Connection” 192.168.1.2 255.255.255.0


netsh -r hostname -u domain\admin -p password interface ip show config


<#

netsh interface ipv4

set address [name=]InterfaceName [source=]{dhcp | static [addr=]IPAddress [mask=]SubnetMask [gateway=]{none | DefaultGateway [[gwmetric=]GatewayMetric]}}

Parameters

[ name = ] InterfaceName   : Required. 
    Specifies the name of the interface for which you want to configure address and gateway information. 
    The InterfaceName parameter must match the name of the interface as specified in Network Connections. 
    If InterfaceName contains spaces, use quotation marks around the text (for example, "Interface Name").

[ source= ]{ dhcp | static [ addr= ] IPAddress [ mask= ] SubnetMask [ gateway= ]{ none | DefaultGateway [[ gwmetric= ] GatewayMetric ]}} : Required. 
    Specifies whether the IP address to configure originates from a Dynamic Host Configuration Protocol (DHCP) server or is static. 
    If the address is static, IPAddress specifies the address to configure, and SubnetMask specifies the subnet mask for the IP address being configured. 
    If the address is static, you must also specify whether you want to leave the current default gateway (if any) in place or configure one for the address. 
    If you configure a default gateway, DefaultGateway specifies the IP address of the default gateway to be configured, and GatewayMetric specifies the metric for the default gateway to be configured.

#>