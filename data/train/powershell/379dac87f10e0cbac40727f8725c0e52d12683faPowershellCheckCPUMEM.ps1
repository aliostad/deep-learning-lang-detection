

$AVGProc = Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average 

Write-host -nonewline "CPU USAGE: `t"
for ( $i = 0; $i -lt [int]$AVGProc.Average ; $i++){

    Write-host -nonewline "|"
}
Write-host ""

$OS = gwmi -Class win32_operatingsystem | Select-Object @{Name = "MemoryUsage"; Expression = {“{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }} 

$OS

#$AVGProc = Get-WmiObject -computername $computername win32_processor | Measure-Object -property LoadPercentage -Average | Select Average 
#$OS = gwmi -Class win32_operatingsystem -computername $computername | Select-Object @{Name = "MemoryUsage"; Expression = {“{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }} 