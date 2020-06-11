# This scripts allows you to search for long paths on Sharepoint Online document libraries that
# normally causing synchronization issues with OneDrive for Business 2013. The limitations and
# restrictions are described at http://support.microsoft.com/kb/2933738
# Author: David Rodriguez (@davidjrh)
# Version 1.0 - September 24th, 2014


# Requirements:
# Sharepoint Server 2013 Client Components SDK: http://www.microsoft.com/en-ie/download/details.aspx?id=35585

# References:
# Create and Manage SharePoint Online Sites by Using PowerShell
# http://blogs.technet.com/b/heyscriptingguy/archive/2014/04/24/create-and-manage-sharepoint-online-sites-by-using-powershell.aspx

param (
    [string]$SiteName = $(throw "-SiteName is required."),
    [string]$DocumentLibraryName = "",
    [PSCredential]$Credential = $null,
    [switch]$Verbose
)

$numberOfFiles = 0
$illegalChars = "[\\/:*?""<>|#]"
$ErrorActionPreference = "Stop"
$VerbosePreference = "SilentlyContinue"
if ($Verbose) { $VerbosePreference = "Continue" }

# Searchs for files not suitable for OneDrive for Bussiness because of restrictions
function Process-Folder($ctx, $folder, $localFolder) {
    $ctx.Load($folder)
    $ctx.Load($folder.Files)
    $ctx.Load($folder.Folders)
    $ctx.ExecuteQuery()
    Write-Verbose "Processing $($folder.ServerRelativeUrl)..."

    # 1. Folder names can have up to 250 chars
    if ($folder.Name.Length -gt 250) {
        Write-Warning "$($folder.ServerRelativeUrl) (folder name longer than 250 chars)"
    }

    # 2. Local folder path can have up to 250 chars
    $localFolderPath = "$localFolder$($folder.ServerRelativeUrl.Substring(1))"
    if ($localFolderPath.Length -gt 250) {
        Write-Warning "$($folder.ServerRelativeUrl) (local folder path longer than 250 chars)"
    }

    foreach ($file in $folder.Files)
    {
        Write-Verbose "Processing $($file.ServerRelativeUrl)..."
        # 3. File names can have up to 128 characters
        if ($file.Name.Length -gt 128) {
            Write-Warning "$($file.ServerRelativeUrl) (file name longer than 128 chars)"
        }

        # 4. Folder + File name can have up to 250 characters
        if ($file.ServerRelativeUrl.Length -gt 250) {
            Write-Warning "$($file.ServerRelativeUrl) (file path longer than 250 chars)"
        }

        # 5. Local file path can have up to 250 characters
        $localFilePath = "$localFolder$($file.ServerRelativeUrl.Substring(1))"
        if ($localFilePath.Length -gt 250) {
            Write-Warning "$($file.ServerRelativeUrl) (local file path longer than 250 chars)"
        }

        # 6. Can sync more than 5000 items per document library
        $numberOfFiles++
        if ($numberOfFiles -eq 5000) {
            Write-Warning "$($file.ServerRelativeUrl) (reached 5000 items)"
        }

        # 7. File size can not be longer than 2GB (who in the hell is storing a 2GB file on Sharepoint Online?)
        if ($file.Length -gt 2048000000) {
            Write-Warning "$($file.ServerRelativeUrl) (file size greater than 2GB)"
        }

        # 8. Check illegal chars
        if (($file.Name -match $illegalChars) -or ($file.Name.StartsWith("~")) -or ($file.Name.StartsWith("."))) {
            Write-Warning "$($file.ServerRelativeUrl) (illegal file name)"
        }
    }

    foreach ($subfolder in $folder.Folders)
    {
        Process-Folder $ctx $subfolder $localFolder
    }
}

    
# Load the Sharepoint Client assemblies
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Add-Type -Path "$scriptPath\Microsoft.SharePoint.Client.dll"
Add-Type -Path "$scriptPath\Microsoft.SharePoint.Client.Runtime.dll"

# Instantiate a new SPOContext providing your SharePoint Online site URL. (Don’t forget the https)
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteName)

# Setup credentials
$cred = Get-Credential -Credential $Credential
$credentials = New-Object Microsoft.Sharepoint.Client.SharepointOnlineCredentials($cred.UserName, $cred.Password)
$ctx.Credentials = $credentials

# Connecting to the site
Write-Host "Connecting to $siteName..."
$web = $ctx.Web
$ctx.Load($web)
$ctx.ExecuteQuery()
Write-Host "Connected to $($web.Title)..."

# Obtaining lists
Write-Host "Obtaining lists..."
$lists = $web.Lists
$ctx.Load($lists)
$ctx.ExecuteQuery()

# Process document libraries
foreach ($list in $lists) {    
    if ($list.BaseType -eq "DocumentLibrary") {
        if (($DocumentLibraryName -ne "") -and ($list.Title -ne $DocumentLibraryName)) { continue }
        $localFolder = $env:HOMEDRIVE + $env:HOMEPATH + "\Sharepoint\$($web.Title) - "
        Write-Host "Processing list ""$($list.Title)"", local path ""$localFolder$($list.Title)""..."
        Process-Folder $ctx $list.RootFolder $localFolder
    }
}                    
