# Load the SharePoint 2013 .NET Framework Client Object Model libraries. # 
Add-Type –Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll" 
Add-Type –Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Taxonomy.dll"  

$serverURL = “https://<your tennant>.sharepoint.com”
$siteUrl = $serverURL+"/documents”
$destination = "C:\Export"
$DocumentLibary = "Products"
$downloadEnabled = $false
$versionEnabled = $false

# Authenticate with the SharePoint Online site. # 
$username = "<username @ domain or onmicrosoft.com>"
$Password = "<your password>"
$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force  

$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl) 
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $securePassword) 
$clientContext.Credentials = $credentials 
if (!$clientContext.ServerObjectIsNull.Value) 
{ 
    Write-Output "Connected to SharePoint Online site: '$siteUrl'"
} 


function HTTPDownloadFile($ServerFileLocation, $DownloadPath)
{
#Download the file from the version's URL, download to the $DownloadPath location
    $webclient = New-Object System.Net.WebClient
    $webclient.credentials = $credentials
    Write-Output "Download From ->'$ServerFileLocation'"
    Write-Output "Write to->'$DownloadPath'"
    $webclient.Headers.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f")
    $webclient.DownloadFile($ServerFileLocation,$DownloadPath)
}

function Get-FileVersions ($file, $destinationFolder)
{
    $clientContext.Load($file.Versions)
    $clientContext.ExecuteQuery()
    foreach($version in $file.Versions)
    {
        #Add version label to file in format: [Filename]_v[version#].[extension]
        $filesplit = $file.Name.split(".") 
        $fullname = $filesplit[0] 
        $fileext = $filesplit[1] 
        $FullFileName = $fullname+"_v"+$version.VersionLabel+"."+$fileext           

        #Can't create an SPFile object from historical versions, but CAN download via HTTP
        #Create the full File URL using the Website URL and version's URL
        $ServerFileLocation = $siteUrl+"/"+$version.Url

        #Full Download path including filename
        $DownloadPath = $destinationfolder+"\"+$FullFileName
        
        if($downloadenabled) {HTTPDownloadFile "$ServerFileLocation" "$DownloadPath"}

    }
}

function Get-FolderFiles ($Folder)
{
    $clientContext.Load($Folder.Files)
    $clientContext.ExecuteQuery()

    foreach ($file in $Folder.Files)
        {

            $folderName = $Folder.ServerRelativeURL
            $folderName = $folderName -replace "/","\"
            $folderName = $destination + $folderName
            $fileName = $file.name
            $fileURL = $file.ServerRelativeUrl
            
                
            if (!(Test-Path -path $folderName))
            {
                $dest = New-Item $folderName -type directory 
            }
                
            Write-Output "Destination -> '$folderName'\'$filename'"

            #Create the full File URL using the Website URL and version's URL
            $ServerFileLocation = $serverUrl+$file.ServerRelativeUrl

            #Full Download path including filename
            $DownloadPath = $folderName + "\" + $file.Name
                    
            if($downloadEnabled) {HTTPDownloadFile "$ServerFileLocation" "$DownloadPath"}

            if($versionEnabled) {Get-FileVersions $file $folderName}
            
    }
}


function Recurse($Folder) 
{
       
    $folderName = $Folder.Name
    $folderItemCount = $folder.ItemCount

    Write-Output "List Name ->'$folderName'"
    Write-Output "Number of List Items->'$folderItemCount'"

    if($Folder.name -ne "Forms")
        {
            Get-FolderFiles $Folder
        }
 
    Write-Output $folder.ServerRelativeUrl
 
    $thisFolder = $clientContext.Web.GetFolderByServerRelativeUrl($folder.ServerRelativeUrl)
    $clientContext.Load($thisFolder)
    $clientContext.Load($thisFolder.Folders)
    $clientContext.ExecuteQuery()
            
    foreach($subfolder in $thisFolder.Folders)
        {
            Recurse $subfolder  
        }       
}


function Parse-Lists ($Lists)
{
$clientContext.Load($Lists)
$clientContext.Load($Lists.RootFolder.Folders)
$clientContext.ExecuteQuery()
    
    foreach ($Folder in $Lists.RootFolder.Folders)
        {
           recurse $Folder
        }

}

$rootWeb = $clientContext.Web
$LibLists = $rootWeb.lists.getByTitle($DocumentLibary)
$clientContext.Load($rootWeb)
$clientContext.load($LibLists)
$clientContext.ExecuteQuery()

Parse-Lists $LibLists
