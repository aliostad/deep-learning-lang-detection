############################################################################################################################################
# This script allows to enable the save as template feature for publishing sites
# Required parameters
#   ->$sSiteUrl: Site Url
############################################################################################################################################
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) 
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell }

$host.Runspace.ThreadOptions = "ReuseThread"

#Variables necesarias
$sSiteUrl = “http://demo2010a:90/sites/IntranetMM/”

#Function that allows o change the SaveSiteAsTemplateEnabled property
function Enable-SavePublishingSiteAsTemplate
{
    param ($sSiteUrl)
    try
    {        
        $spWeb=Get-SPWeb $sSiteUrl
        $spWeb.AllProperties["SaveSiteAsTemplateEnabled"] = "true"
        $spWeb.Update()
        Write-host "Updated $sSiteUrl SaveSiteAsTemplateEnabled property to" $spWeb.AllProperties["SaveSiteAsTemplateEnabled"] -foregroundcolor Green
        $spWeb.Dispose()
    }
    catch [System.Exception]
    {
        write-host -f red $_.Exception.ToString()
    }
}

Start-SPAssignment –Global
Enable-SavePublishingSiteAsTemplate -sSiteUrl $sSiteUrl
Stop-SPAssignment –Global

Remove-PSSnapin Microsoft.SharePoint.PowerShell

Remove-PSSnapin Microsoft.SharePoint.PowerShell