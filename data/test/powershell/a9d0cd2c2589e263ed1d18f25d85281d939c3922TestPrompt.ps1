[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic") | Out-Null
$sRet = [Microsoft.VisualBasic.Interaction]::MsgBox("An error occurred when attempting to locate a HDD drive.",'YesNo,Question', "Error encountered")
Write-Host $sRet
