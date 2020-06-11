    $joinPath = "C:", "D:", "E:", "F:", "G:"
$assignUSBLetter = ""
foreach($unit in $joinPath){
    $pathToTest = $unit + "\os.vhd"
    $findUSB = Test-Path $pathToTest
    if ($findUSB){
        $assignUSBLetter = $unit
    }
}

<#
    $pathToVHD = $assignUSBLetter + "\os.vhd"
    $pathToFile = $assignUSBLetter + "\vhdmountos.TXT"
    New-Item  $pathToFile -type file -force
    $fline = "`Select vdisk file =" + $pathToVHD 
    Add-Content $pathToFile $fline 
    Add-Content $pathToFile "`nAttach vdisk"


    $findVHD = Test-Path $pathToVHD

if ($findVHD){
   
    $scriptFile = "/s " + $assignUSBLetter + "\vhdmountos.TXT"
    
    Start-Process "diskpart.exe" -argumentlist $scriptFile -wait 
   
  }

#$letterValue = @()
$driveletter = Get-WMIObject Win32_Volume | select DriveType, DriveLetter, capacity
$osLetter = ""
foreach($drive in $driveletter){
    $size = ($drive.capacity) / 1GB
     #[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
     #[System.Windows.Forms.MessageBox]::Show($drive.driveLetter)
    if (($size -lt 6) -and ($size -gt 5)){
        if ($drive.driveLetter){ 
            $osLetter = $drive.driveLetter 
            #$letterValue +=$drive.driveLetter

            }
    }
}


   
   
   
    $osDisableParameters = "-protectors -enable " + $osLetter
    $osLock = "-lock " + $osLetter
    #$misDocumentosDisableParameters = "-protectors -enable M:"

     #[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
     #[System.Windows.Forms.MessageBox]::Show($osDisableParameters)

    Start-Process "manage-bde.exe" -argumentlist $osDisableParameters -wait

     #[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
     #[System.Windows.Forms.MessageBox]::Show($osLock)

    Start-Process "manage-bde.exe" -argumentlist $osLock -nonewwindow -wait
    #>

    $appsFolder = $assignUSBLetter + "\Deploy\Applications\*"

    $misDocumentosFolder = $assignUSBLetter + "\Deploy\Operating Systems\D Drive Sucursales\*"

    $deletingScripts1 = $assignUSBLetter + "\Deploy\Scripts\decryptfile2.Ps1"
    $deletingScripts2 = $assignUSBLetter + "\Deploy\Scripts\settingComputerInfo.ps1"

    Try{
    remove-item $appsFolder -Recurse -Force -exclude *System*, *RECYCLE.BIN* -ErrorAction Stop
    remove-item $misDocumentosFolder -Recurse -Force -exclude *System*, *RECYCLE.BIN* -ErrorAction Stop
    remove-item $deletingScripts1 -Recurse -Force -exclude *System*, *RECYCLE.BIN* -ErrorAction Stop
    remove-item $deletingScripts2 -Recurse -Force -exclude *System*, *RECYCLE.BIN* -ErrorAction Stop

}catch{}

    

    #falta remover lo que se copio a la memoria y revisar el tema de verify registry