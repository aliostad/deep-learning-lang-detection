$cmd = $args[0]
if ($cmd -eq "process") {
    [String]$res = Get-Process | Format-Table Id,ProcessName,vm,CPU -hidetableheader | Out-String
    Write-Output $res
}
if ($cmd -eq "cpu") {
    [String]$res = Get-WmiObject win32_processor | select LoadPercentage | Format-List | Out-String
    $res = $res -replace "LoadPercentage : ",""
    Write-Output $res
}
if ($cmd -eq "total_mem") {
    $res = Get-WmiObject -Class Win32_ComputerSystem
    $res = $res.TotalPhysicalMemory/1mb
    Write-Output $res
}
if ($cmd -eq "free_mem") {
    $res  = Get-WmiObject Win32_OperatingSystem
    $res = $res.FreePhysicalMemory / 1024
    Write-Output $res
}
if ($cmd -eq "used_mem") {
    $total = Get-WmiObject -Class Win32_ComputerSystem
    $free = Get-WmiObject Win32_OperatingSystem
    $total = $total.TotalPhysicalMemory / 1mb
    $free = $free.FreePhysicalMemory / 1024
    $res = ($total-$free)
    Write-Output $res
}