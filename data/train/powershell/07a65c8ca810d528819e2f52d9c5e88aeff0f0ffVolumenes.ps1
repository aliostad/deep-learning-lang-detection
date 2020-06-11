$driveletter = Get-WMIObject Win32_Volume | select label, DriveLetter | convertto-csv
$recipients = $driveletter -split ","
$arrayNumber = 0
foreach ($drive in $recipients){
    $arrayNumber = $arrayNumber + 1
    $drivername = $drive | Select-String -Pattern "IMAGEN" -quiet
    if ($drivername){
        $arrayPosition = ($arrayNumber)
    }
}
$removecolons = $recipients[$arrayPosition]
$getLetterValue  = $removecolons.substring(1,1)
 [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
 [System.Windows.Forms.MessageBox]::Show($getLetterValue)
$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment 
$tsenv.Value("USMTPATH") = $getLetterValue
$tsenv.Value("USMT_WORKING_DIR") = $getLetterValue +":\"
 [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
 [System.Windows.Forms.MessageBox]::Show($tsenv.Value("USMTPATH"))