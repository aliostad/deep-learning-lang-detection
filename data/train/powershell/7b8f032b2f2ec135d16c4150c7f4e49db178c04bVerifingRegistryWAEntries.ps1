[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.MessageBox]::Show($tsenv.Value("Revisar registro"))
try{
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" -Name "SkipRearm" -Value 1
Set-ItemProperty -Path "HKLM:\SYSTEM\Setup\Status\SysprepStatus" -Name "GeneralizationState" -Value 7
}catch{}
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.MessageBox]::Show($tsenv.Value("Revisar valores nuevos"))