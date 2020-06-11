
Write-Host "test connectivity: "
$servers = "192.168.1.1", "192.168.1.2"

foreach ($server in $servers) {
    Test-Connection -ComputerName $server -Count 1
}

Write-Host ""
Write-Host ""
write-host "test access to c$, d$ and e$ admin shares,"
write-host "This implies AD account with local admin access and existence of disks."

    
foreach ($server in $servers) { 
    Write-Host ""
    Write-Host "testing disks: $server"
    if (-not (Test-Path \\$server\c$)){
        Write-Host "disk C not found" -ForegroundColor Red
    }
    else {
        Write-Host "disk C exists" -ForegroundColor Green       
        $disk = $(Get-WmiObject Win32_LogicalDisk -ComputerName $server -Filter "DeviceID='C:'" | Select-Object Size).Size / (1024 * 1024 * 1024)
        if ($disk -lt 95) {
            Write-Host "disk C te klein: grootte = $disk GB" -ForegroundColor Red
        }
    }    

    if ($server -like '*SQL*' -or 1 -eq 1) {
        if (-not (Test-Path \\$server\d$)){
            Write-Host "disk D not found" -ForegroundColor Red
        }
        else {
            Write-Host "disk D exists" -ForegroundColor Green
            $wmiQuery = "SELECT BlockSize FROM Win32_Volume WHERE FileSystem='NTFS' and DriveLetter = 'd:'"
            $wmiResultBlocksize = $(Get-WmiObject -Query $wmiQuery -ComputerName $server |Select-Object BlockSize ).Blocksize / 1024
            if ($wmiResultBlocksize -ne 64) {
                Write-Host "disk D is not formatted correctly. Blocksize is $wmiResultBlocksize kb and should be 64kb" -ForegroundColor Red
            }

            $disk = $(Get-WmiObject Win32_LogicalDisk -ComputerName $server -Filter "DeviceID='D:'" | Select-Object Size).Size / (1024 * 1024 * 1024)
            if ($disk -lt 800) {
                Write-Host "disk D too small, size = $disk GB" -ForegroundColor Red
            }
        }   
    }

    if ($server -like '*SQL*' -or $server -like '*BHR*' -or 1 -eq 1) {
        if (-not (Test-Path \\$server\e$)){
            Write-Host "disk E not found" -ForegroundColor Red
        }
        else {
            Write-Host "disk E exists" -ForegroundColor Green
            $wmiQuery = "SELECT BlockSize FROM Win32_Volume WHERE FileSystem='NTFS' and DriveLetter = 'e:'"
            $wmiResultBlocksize = $(Get-WmiObject -Query $wmiQuery -ComputerName $server |Select-Object BlockSize ).Blocksize / 1024
                      

            if ($wmiResultBlocksize -ne 64) {
                Write-Host "disk E is not formatted correctly. Blocksize is $wmiResultBlocksize kb and should be 64kb" -ForegroundColor Red
            }

            $disk = $(Get-WmiObject Win32_LogicalDisk -ComputerName $server -Filter "DeviceID='E:'" | Select-Object Size).Size / (1024 * 1024 * 1024)
            if ($disk -lt 95) {
                Write-Host "disk E too small, size = $disk GB" -ForegroundColor Red
            }
        }   
    }    
}

write-host "";
write-host "Check windows updates";


$referenceServer = $servers[0]
$referenceUpdates = Get-WmiObject Win32_QuickFixEngineering  -ComputerName $referenceServer |Select-Object HotFixId
if ($referenceUpdates -ne $null)
{
    foreach ($server in $servers) {
        $serverUpdates = Get-WmiObject Win32_QuickFixEngineering  -ComputerName $server |Select-Object HotFixId
        if ($serverupdates -ne $null) {
            Compare-Object -ReferenceObject $referenceUpdates -DifferenceObject $serverUpdates -PassThru   
        }
        else {
            write-host "server $server has no updates" -ForegroundColor Red
        }
    }
}
else {
    write-host "Reference server has no updates" -ForegroundColor Red
}

#not working yet
$whoamiResult = whoami /priv 
if ($whoamiResult -like "%SeManageVolumePrivilege%"){
    Write-Host "lock pages on"
}
else {
    Write-Host "lock pages off"
}


