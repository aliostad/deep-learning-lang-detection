$joinPath = "C:", "D:", "E:", "F:", "G:"
$assignUSBLetter = ""
foreach($unit in $joinPath){
    $pathToTest = $unit + "\os.vhd"
    $findUSB = Test-Path $pathToTest
    if ($findUSB){
        $assignUSBLetter = $unit
    }
}
$letterValue = @()
$driveletter = Get-WMIObject Win32_Volume  | select DriveType, DriveLetter, capacity

foreach($drive in $driveletter){
    if ($drive.DriveType -ne 2){
    $size = ($drive.capacity) / 1GB
     #[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
     #[System.Windows.Forms.MessageBox]::Show($drive.driveLetter)
        if ($size -lt 1){
            if ($drive.driveLetter){ 
                #[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
                #[System.Windows.Forms.MessageBox]::Show($drive.driveLetter)
                $letterValue +=$drive.driveLetter
                [Array]::Sort([array]$letterValue)
                $letterValue

                }
        }
    }
}

$pathToFile = $assignUSBLetter + "\volume.TXT"
New-Item  $pathToFile -type file -force
$fline = "`list volume"
Add-Content $pathToFile $fline
$diskPartRedirection = $assignUSBLetter + "\listed.TXT"

$listVolume = "/s " + $assignUSBLetter + "\volume.TXT"
Start-Process "diskpart.exe" -argumentlist $listVolume -RedirectStandardOutput $diskPartRedirection -wait 

$appfounded = $false
$docFounded = $false


$lines = Get-Content $diskPartRedirection


#$lines = Get-Content "C:\windows\system32\result.txt"
foreach ($line in $lines) 
{
    $appfounded = $line | Select-String -Pattern "2500 MB"
    if ($appfounded){
        $gettingLetter = $line -split " "
        $VolumeAppLetter = $gettingLetter[8] + ":"
    }

    $docFounded = $line | Select-String -Pattern "2798 MB"

    if ($docFounded){
        $gettingLetterDoc = $line -split " "
        $VolumeDocLetter = $gettingLetterDoc[8] + ":"
    }


}
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.MessageBox]::Show($VolumeAppLetter)
#$VolumeAppLetter
#$VolumeDocLetter
     

    $appsFolder = $assignUSBLetter + "\Deploy\Applications"

    $misDocumentosFolder = $assignUSBLetter + "\Deploy\Operating Systems\D Drive Sucursales"
    
    $manageBDEappsFolder = $assignUSBLetter + "\manageAppsFolder.txt"

    $manageBDEmisdocFolder = $assignUSBLetter + "\manageMisDocFolder.txt"
   

    $appsFolderParameters = "-unlock " + $VolumeAppLetter + " -recoverypassword 092169-193721-024497-153340-108383-440044-538362-027775"
    

    Start-Process "manage-bde.exe" -argumentlist $appsFolderParameters -nonewwindow -RedirectStandardOutput $manageBDEappsFolder -wait

    $misdocFolderParameters = "-unlock " + $VolumeDocLetter + " -recoverypassword 629079-154022-524700-263626-163603-526009-710215-039545"

    Start-Process "manage-bde.exe" -argumentlist $misdocFolderParameters -nonewwindow -RedirectStandardOutput $manageBDEmisdocFolder -wait


    $appsPath = $VolumeAppLetter + "\*"
    
    copy-Item $appsPath -Destination $appsFolder -recurse -force -exclude *System*, *RECYCLE.BIN*

    $misDocumentosFolder = $assignUSBLetter + "\Deploy\Operating Systems\D Drive Sucursales"

    $misDocPath = $VolumeDocLetter + "\*"



    copy-Item $misDocPath -Destination $misDocumentosFolder -force -exclude *System*, *RECYCLE.BIN*

<#| convertto-csv

$recipients = $driveletter -split ","
$arrayNumber = 0
$devicesId = @()
$letterId = @()
foreach ($drive in $recipients){
   $removeQuotes = $drive.Replace('"',"")
    $removedrive =  $removeQuotes.Contains("#TYPE Selected.System.Management.ManagementObject")
 
       if (($removedrive) -eq $false)
       {
            $devicesId+=$removeQuotes
       }

}
foreach ($rdrive in $devicesId){
    $removeletter =  $rdrive.Contains("DriveLetter")
 
       if (($removeletter) -eq $false)
       {
            $letterId+=$rdrive
       }

}

foreach ($pathSearch in $letterId){
    $joinPath = $pathSearch + "\Windows"
    $deployPath = $pathSearch + "\Deploy"
    $findOS = Test-Path $joinPath
    $findDeploy = Test-Path $deployPath
 
 if (($findOS -eq $true)-and ($pathSearch -ne "X:")){
        $getLetterValue=$pathSearch
    }

}


$pathToVHD = $assignUSBLetter + "\os.vhd"

$findVHD = Test-Path $pathToVHD

if ($findVHD){
   
    $scriptFile = "/s " + $assignUSBLetter + "\vhdmount2.TXT"
    
    Start-Process "diskpart.exe" -argumentlist $scriptFile -wait 
   
  }
    #>