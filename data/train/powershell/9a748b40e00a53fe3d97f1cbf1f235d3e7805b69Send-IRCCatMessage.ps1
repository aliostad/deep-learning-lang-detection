Param(
	[string]$IRCCatHost="127.0.0.1",
	[string]$IRCCatPort="31337",
	[string]$IRCCatChannel="test",
	[string]$Message="Default message",
	[int]$MaxLen=512
)

##
# Send-IRCCatMessage.ps1
# Example usage:
#  .\Send-IRCCatMessage.ps1 -IRCCatHost 'earth' -IRCCatPort 31337 -IRCCatChannel "glo" -Message '[%sitename] %device %name %status %down (%message)'
# Recipient end must accept json encoded message in the format
#  { "method": "say", params: ["#channel", "message"] }
##

$Message = $Message -replace '\s+', ' '

# Split into max length
$msgs = @()
$i = $Message.length
$s = 0
while ($i -gt 0) {
	$nextstop = $MaxLen
	if ($nextstop -gt $i)
	{
		$nextstop = $i
	}
	$msgs += $Message.SubString($s, $nextstop).trim()

	$s = $s + $MaxLen
	$i = $i - $MaxLen
}

$destination = [System.Net.Dns]::GetHostAddresses($IRCCatHost)
$port = $IRCCatPort -as [int]
$enc = [system.Text.Encoding]::UTF8

Foreach ($m in $msgs)
{
	$packet = $enc.GetBytes((New-Object psobject | add-member -PassThru method "say" | add-member -PassThru params @("#$($IRCCatChannel)", $m) | convertto-json))
	if ($packet.length -lt 1)
	{
		continue
	}
	
	$UDPclient = new-Object System.Net.Sockets.UdpClient 
	$UDPclient.Connect($destination, $port) 
	[void]$UDPclient.Send($packet, $packet.length)
}

