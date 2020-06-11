# Backup all files infot specified directory. Because robocopy is used with /PURGE option
# destination paths must be uniqe.
# Source directories - comma separated
$Source_dirs = @("C:\Users\User1\Folder1", "C:\Users\User1\Folder2")
# Backup directory without drive letter
$Dest_dir = "\Backup\TestBackup001"

Add-Type -AssemblyName PresentationFramework

function checkForUsbDrive
{
    while (($Model = (gwmi Win32_DiskDrive | where {$_.MediaType -eq 'External hard disk media'}).Model) -eq $null) {
        if ([System.Windows.MessageBox]::Show('Připojte externí disk', 'Záloha', 'OKCancel', 'Exclamation') -eq 'Cancel') {
            [System.Windows.MessageBox]::Show('Záloha nebyla provedena - nenalezen USB disk', 'Záloha', 'OK', 'Error')
            exit
        }
    }
    $Model
}

# Get drive letter of removable hard disk media type
function getExtHddLetter
{
    gwmi win32_diskdrive | ? {$_.MediaType -eq "External hard disk media"} `
        | %{gwmi -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=`"$($_.DeviceID.replace('\','\\'))`"} WHERE AssocClass = Win32_DiskDriveToDiskPartition"} `
        | %{gwmi -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=`"$($_.DeviceID)`"} WHERE AssocClass = Win32_LogicalDiskToPartition"} `
        | %{$_.deviceid}
}

# Eject removable drive
function ejectExtDrive
{
    $vol = gwmi Win32_Volume | where {$_.Name -eq (getExtHddLetter)}
    $vol.DriveLetter = $null
    $vol.Put()
    $vol.Dismount($false, $false)
}

try {
    $model = checkForUsbDrive
    Write-Information "Got USB device: $model"
    $driveLetter = getExtHddLetter
    Write-Information " on $driveLetter drive letter"
    Write-Warning "Starting backup to $driveLetter$Dest_dir"
    foreach ($source in $Source_dirs) {
        Write-Information " copying files from $source..."
        $dest = Join-Path $driveLetter$Dest_dir (SPlit-Path $source -Leaf)
        robocopy $source $dest *.* /J /MIR /ETA 
    }
    if ([System.Windows.MessageBox]::Show('Záloha je hotova.\r\nChcete odpojit disk?', 'Hotovo', 'YesNo', 'Question') -eq 'Yes') {
        ejectExtDrive
        [System.Windows.MessageBox]::Show('Můžete odpojit kabel', 'Hotovo', 'OK', 'Asterisk')
    }
}
catch {
    [System.Windows.MessageBox]::Show($_, 'Chyba', 'OK', 'Error')
}
