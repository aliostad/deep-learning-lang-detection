[int] $Port = 5006

# report this to the master
$IP = "10.1.1.1"
$Address = [system.net.IPAddress]::Parse($IP)
$End = New-Object System.Net.IPEndPoint $Address, $Port

# Create socket
$Saddrf = [System.Net.Sockets.AddressFamily]::InterNetwork
$Stype = [System.Net.Sockets.SocketType]::Dgram
$Ptype = [System.Net.Sockets.ProtocolType]::UDP
$Sock = New-Object System.Net.Sockets.Socket $Saddrf, $Stype, $Ptype
$Sock.TTL = 26

# Connect to socket
$Sock.Connect($End)


$Cname = gc env:computername
$Message = "Error on AC test script for laptop $Cname"

$charging = [BOOL](Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ComputerName "localhost").PowerOnLine 

if( $charging -eq $false ) {
	$Message = "$Cname is NOT ON AC."
	echo $Message

	#Create encoded buffer
	$Enc = [System.Text.Encoding]::ASCII
	$Buffer = $Enc.GetBytes($Message)

	#Send the buffer
	$Sent = $Sock.Send($Buffer)

} else {
	$Message = "$Cname is on AC."
	#echo $Message
}
