function Get-LatestShadowCopy($Ltr)
{
    $Ltr = $Ltr.Trim("\\")
    $Disk = Get-WmiObject -Class Win32_Volume | Where { $_.DriveLetter -eq $Ltr }
    $LastSnap = (Get-WMIObject win32_shadowcopy) | Where { $_.VolumeName -eq $Disk.DeviceId -and $_.ClientAccessible -eq $true } | Sort InstallDate | Select-Object -Last 1
    return $LastSnap
}

function Update-ShadowCopy($Ltr)
{
    if ((Get-WmiObject Win32_ShadowCopy -List).Create($Ltr,"ClientAccessible"))
    {
        return Get-LatestShadowCopy($Ltr)
    }
	
	writeLog("ShadowCopy Failed")
    throw "ShadowCopy Failed"
}