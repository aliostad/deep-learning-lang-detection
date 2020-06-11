[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

Clear-Host
$log = Get-EventLog -logname "system" | Where-Object { $_.EventID -eq 1074 } | Select-Object -First 1
if ($_.Message -like "*power off*")
{
[System.Windows.Forms.MessageBox]::Show("Last shutdown was a power off.")
# Restart-Computer
} else {
[System.Windows.Forms.MessageBox]::Show("Last shutdown was not a power off.")
}
