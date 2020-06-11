Add-PSSnapin Microsoft.SharePoint.PowerShell

Get-SPWebApplication | ForEach {
    $webApp = $_

    $info = New-Object PSObject -Property @{
        WebAppUrl = $webApp.GetResponseUri([Microsoft.SharePoint.Administration.SPUrlZone]::Default).AbsoluteUri
        AllowDesigner = $webApp.AllowDesigner
        AllowCreateDeclarativeWorkflow = $webApp.AllowCreateDeclarativeWorkflow
        AllowMasterPageEditing = $webApp.AllowMasterPageEditing
        AllowRevertFromTemplate = $webApp.AllowRevertFromTemplate
        AllowSaveDeclarativeWorkflowAsTemplate = $webApp.AllowSaveDeclarativeWorkflowAsTemplate
        AllowSavePublishDeclarativeWorkflow = $webApp.AllowSavePublishDeclarativeWorkflow
        ShowURLStructure = $webApp.ShowURLStructure
    }
    Write-Output $info
} | Export-Csv "$PSScriptRoot\SPWebApplicationDesignerSettings.csv" -NoTypeInformation 


Get-SPWebApplication | Get-SPSite -Limit ALL | ForEach {
    $site = $_
    
    $info = New-Object PSObject -Property @{
        SiteUrl = $Site.Url
        AllowDesigner = $site.AllowDesigner
        AllowCreateDeclarativeWorkflow = $site.AllowCreateDeclarativeWorkflow
        AllowSaveDeclarativeWorkflowAsTemplate = $site.AllowSaveDeclarativeWorkflowAsTemplate
        AllowSavePublishDeclarativeWorkflow = $site.AllowSavePublishDeclarativeWorkflow
        AllowMasterPageEditing = $site.AllowMasterPageEditing
        AllowRevertFromTemplate = $site.AllowRevertFromTemplate
        ShowURLStructure = $site.ShowURLStructure
    }
    Write-Output $info
} | Export-Csv "$PSScriptRoot\SPSiteDesignerSettings.csv" -NoTypeInformation 


Get-SPWebApplication | Get-SPSite -Limit ALL | Get-SPWeb -Limit ALL | ForEach {
    $web = $_

    $key = "vti_disablewebdesignfeatures2"

    if($web.AllProperties.ContainsKey($key)) {
        Write-Host $web.Url ' - ' $web.AllProperties[$key]
        $info = New-Object PSObject -Property @{
            SiteUrl = $web.Site.Url
            WebUrl = $web.Url
            vti_disablewebdesignfeatures2 = $web.AllProperties[$key]
        }
        Write-Output $info
    }
} | Export-Csv "$PSScriptRoot\SPWebDesignerSettings2007.csv" -NoTypeInformation 