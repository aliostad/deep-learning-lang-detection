###############################################################################

Import-Module prtgshell

###############################################################################
<#

# old stuff for the RCA modem

$PageData = Invoke-WebRequest http://192.168.100.1/diagnostics_page.asp

"<prtg>`n"

Set-PrtgResult "Forward Path (Upstream) SNR" ([double](($PageData.AllElements | ? {$_.name -eq "DSSnrInfo" }).value.split(" "))[0]) "dB" -ShowChart
Set-PrtgResult "Forward Path (Upstream) Received Signal Strength" ([double](($PageData.AllElements | ? {$_.name -eq "DSSigInfo" }).value.split(" "))[0]) "dBmV" -ShowChart
Set-PrtgResult "Return Path (Downstream) Power Level" ([double](($PageData.AllElements | ? {$_.name -eq "USPwrInfo" }).value.split(" "))[0]) "dBmV" -ShowChart

"</prtg>"

#"forward path snr"
#$PageData.AllElements | ? {$_.name -eq "DSSnrInfo" } | select value
#"forward path received signal strength"
#$PageData.AllElements | ? {$_.name -eq "DSSigInfo" } | select value
#"return path power level"
#$PageData.AllElements | ? {$_.name -eq "USPwrInfo" } | select value

#>

###############################################################################

$PageData = Invoke-WebRequest http://192.168.100.1/cmSignalData.htm

$TableCells = $PageData.AllElements | ? { $_.tagName -eq "TD" }
$TableDataOnly = $TableCells | % { $_.innerText }

###############################################################################

<# this is how the data lines up

Downstream Channel ID
$TableDataOnly[1] - [8]

Downstream Frequency
$TableDataOnly[10] - [17]

Downstream SNR
$TableDataOnly[19] - [26]

Downstream Modulation
$TableDataOnly[28] - [35]

Downstream Power Level
$TableDataOnly[38] - [45]

Upstream Channel ID
$TableDataOnly[47] - [49]

Upstream Frequency
$TableDataOnly[51] - [53]

Upstream Symbol Rate
$TableDataOnly[59] - [61]

Upstream Power Level
$TableDataOnly[63] - [65]

#>

###############################################################################
# output

"<prtg>`n"

Set-PrtgResult "Downstream SNR" (19..26 | % { ([double]($TableDataOnly[$_].split(" "))[0]) } | Measure-Object -Average).Average "dB" -ShowChart
Set-PrtgResult "Downstream Power" (38..45 | % { ([double]($TableDataOnly[$_].split(" "))[0]) } | Measure-Object -Average).Average "dBmV" -ShowChart
Set-PrtgResult "Upstream Power" (63..65 | % { ([double]($TableDataOnly[$_].split(" "))[0]) } | Measure-Object -Average).Average "dBmV" -ShowChart

"</prtg>"