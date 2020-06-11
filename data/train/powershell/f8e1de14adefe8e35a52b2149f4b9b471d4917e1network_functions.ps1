write-debug "LOAD network_functions"
## Networking functions
function show-interfaces { gwmi win32_networkadapterconfiguration | ?{$_.ipaddress} }
function show-netconfig { param($if="wireless network connection"); netsh interface ipv4 show config $if }
function show-netinterfaces { netsh interface ipv4 show interfaces }
function show-netroute { netsh interface ipv4 show route }

function get-proxy
{
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	$reg = get-itemproperty $path
	return $reg
}

function set-proxy
{
	param(
		[string]$proxy = "proxy.example.com:888",
		[string]$override = "*.localhost;*.localdomain"
	)
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	set-itemproperty -path $path -name "ProxyServer" -value $proxy
	set-itemproperty -path $path -name "ProxyOverride" -value $override
}

function set-proxyenabled
{
	param([bool]$enable=$False)
	$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	$en = 0
	if($enable) { $en = 1 }
	set-itemproperty -path $path -name "ProxyEnable" -value $en
}

function enable-proxy { set-proxyenabled -enable $True }
function disable-proxy { set-proxyenabled -enable $False }
function get-proxyserver { (get-proxy).ProxyServer } 
function get-proxystatus { return (get-proxy).ProxyEnable }
write-debug "DONE loading network_functions"
