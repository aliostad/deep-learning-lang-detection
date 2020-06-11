$compname = $env:COMPUTERNAME.tolower()

$wmiCpu = @()
$wmiCpu += Get-WmiObject -Class Win32_Processor | Select-Object deviceid,loadpercentage

## Set the Graphite carbon server location and port number
$carbonServer = "graphite.cat.pdx.edu"
$carbonServerPort = 2003

#Get Unix epoch Time
$epochTime=[int](Get-Date -UFormat "%s") + 28800

## Formatted for Graphite
$graphiteStrings = @()
foreach ($cpu in $wmiCpu) {
	$loadAvg = 0 + $cpu.loadpercentage # When loadpercentage == 0 the value in WMI is null. This corrects for that.
	$graphiteStrings += ("wintel.terminal_server.${compname}_ds_cecs_pdx_edu.loadpercent.$($cpu.deviceid) " + $loadAvg + " " + $epochTime)
}

# Stream results to the Carbon server
$socket = New-Object System.Net.Sockets.TCPClient
$socket.connect($carbonServer, $carbonServerPort)
$stream = $socket.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)

##Write out metric to the stream.
foreach ($str in $graphiteStrings) {
	$writer.WriteLine($str)
}

#Flush and write our metrics.
$writer.Flush()
$writer.Close()
$stream.Close()