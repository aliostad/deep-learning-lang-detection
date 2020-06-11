$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$upath = $tsenv.Value("DeployRoot")
$udpath = $upath + "\tools\x86\hostsold\"
$pathToFile = $udpath + "\migrationinfo.txt"
$readingComputerInfo = Get-Content $pathToFile
 #[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
 #[System.Windows.Forms.MessageBox]::Show($tsenv.Value($pathToFile))
foreach ($info in $readingComputerInfo) 
{
    $computerData = $info -split ";"
}
$tsenv.Value("OSDComputerName") = $computerData[0]
$tsenv.Value("MachineObjectOU") = $computerData[1]
$tsenv.Value("AdminPassword") = "W7Oficin@s2015"




 #[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
 #[System.Windows.Forms.MessageBox]::Show($tsenv.Value("OSDComputerName"))
 #[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
 #[System.Windows.Forms.MessageBox]::Show($tsenv.Value("MachineObjectOU"))