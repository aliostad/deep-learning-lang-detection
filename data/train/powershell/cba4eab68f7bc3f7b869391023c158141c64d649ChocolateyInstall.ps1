try 
{ 

	#try load the sharepoint module
	if ((Add-PSSnapin Microsoft.SharePoint.PowerShell -EA SilentlyContinue) -eq $null -and (Get-PSSnapin Microsoft.SharePoint.PowerShell -EA SilentlyContinue) -eq $null)
    {
        throw "Could not load SharePoint PowerShell Snapin"
    }
    
    #locate the SharePoint hive
	$path = [Microsoft.SharePoint.Utilities.SPUtility]::GetGenericSetupPath($null)
    $links = "$env:USERPROFILE\links"
    
    if ($path -match "15\\$")
    {
        $shortcut = "$links\15.lnk"
    }
    elseif ($path -match "14\\$")
    {
        $shortcut = "$links\14.lnk"
    }
    elseif ($path -match "12\\$")
    {
        $shortcut = "$links\12.lnk"
    }
    else
    {
        $shortcut = "$links\SharePoint.lnk"
    }

    #get shell object
    $wshShellObject = New-Object -com WScript.Shell
    
    #set the properties
    $wshShellLink = $wshShellObject.CreateShortcut($shortcut)
    $wshShellLink.TargetPath = $path
    $wshShellLink.WindowStyle = 1
    $wshShellLink.Save()

    Write-ChocolateySuccess 'SharePoint.HiveShortCut.Explorer created Shortcut in explorer'
} 
catch 
{
  Write-ChocolateyFailure 'SharePoint.HiveShortCut.Explorer' "$($_.Exception.Message)"
  throw 
}