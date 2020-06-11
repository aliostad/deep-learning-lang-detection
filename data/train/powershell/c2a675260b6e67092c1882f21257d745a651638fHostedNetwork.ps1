Write-Host '1. Configure HostedNetwork'
Write-Host '2. Start HostedNetwork'
Write-Host '3. Show HostedNetwork'
Write-Host '4. Stop HostedNetowrk'
While($true){
$option = Read-Host 'Enter option: '
If($option -eq 1) {
    $ssid = Read-Host 'Enter SSID: '
    $wlanpw = Read-Host 'Enter Password for WPA2 Personal: ' -assecurestring
    $wlanpw_plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($wlanpw))
    netsh wlan set hostednetwork mode=allow ssid=$ssid key=$wlanpw_plain keyUsage=persistent
    }
    ElseIf ($option -eq 2) {
    netsh wlan start hostednetwork
    }
    ElseIf ($option -eq 3) {
    netsh wlan show hostednetwork
    }
    ElseIf ($option -eq 4) {
    netsh wlan stop hostednetwork
    }
	Else {
	exit
	}
}