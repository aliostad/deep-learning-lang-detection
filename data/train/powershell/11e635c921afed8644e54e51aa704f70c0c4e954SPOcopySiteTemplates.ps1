param
(   
    [Parameter(Mandatory=$true)][string]$URL = "https://potashcorp.sharepoint.com",
    [Parameter(Mandatory=$true)][string]$UrlDest,
    [Parameter(Mandatory=$true)][string]$FileName = "Department Portal",
    [Parameter(Mandatory=$true)][string]$FileURL = "https://potashcorp.sharepoint.com/_catalogs/solutions/Department%20Portal.wsp",
    [Parameter(Mandatory=$true)][string]$Username,
    [SecureString]$Password = $( Read-Host "Input password, please" -AsSecureString  )
)

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Publishing")

Function Get-SPOCredentials($UserName, $Password)
{
   return New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,$Password)
}
#delete a file
Function DeleteWSP($File2Delete)
{
    $File2Delete.DeleteObject()
    $contextDest.ExecuteQuery()
}

#load the contexts with the provided credentials
$context = New-Object Microsoft.SharePoint.Client.ClientContext($URL)
$context.Credentials = Get-SPOCredentials $UserName $Password
$contextDest = New-Object Microsoft.SharePoint.Client.ClientContext($UrlDest)
$contextDest.Credentials = Get-SPOCredentials $UserName $Password

#get the source file
$solutionCatalog = 121
$web = $context.Site.RootWeb
$file = $web.GetFileByUrl($FileURL)
$newFileBytes = $file.OpenBinaryStream()
$context.Load($web)
$context.Load($file)
$context.ExecuteQuery()

#get the destination properties
$siteDest = $contextDest.Site
$catalogDest = $siteDest.GetCatalog($solutionCatalog)
$contextDest.Load($siteDest)
$contextDest.Load($catalogDest)
$contextDest.ExecuteQuery()

#copy the file from the source to the destination
$FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation
$FileCreationInfo.Overwrite = $true
$FileCreationInfo.ContentStream = $newFileBytes.Value
$FileCreationInfo.URL = $file.Name
$FileUpload = $catalogDest.RootFolder.Files.Add($FileCreationInfo)

$contextDest.load($FileUpload)
$contextDest.ExecuteQuery()

#set all the wsp properties
$spoDesignPackageInfo = New-Object Microsoft.SharePoint.Client.Publishing.DesignPackageInfo
#explicitly specify this so we know the ID when removing other wise use: [GUID]::Empty
$spoDesignPackageInfo.PackageGuid = "6EB6F606-8985-4A99-B49C-C007F91A9F90"
$spoDesignPackageInfo.MajorVersion = 1
$spoDesignPackageInfo.PackageName = $FileName
$sSolutionRelativePath = $siteDest.ServerRelativeUrl + "/_catalogs/solutions/" + $file.Name
$sSolutionRelativePath

#uninstall the previous version (if it exists) and install the new copy
$spoDesignPackage = [Microsoft.SharePoint.Client.Publishing.DesignPackage] 
$spoDesignPackage::UnInstall($contextDest,$contextDest.Site,$spoDesignPackageInfo)
$spoDesignPackage::Install($contextDest,$contextDest.Site,$spoDesignPackageInfo,$sSolutionRelativePath)
$contextDest.ExecuteQuery()

#when a wsp is activated in code it creates a new copy
#delete the temporary file
DeleteWSP $FileUpload
#cleanup
$context.Dispose()
$contextDest.Dispose()