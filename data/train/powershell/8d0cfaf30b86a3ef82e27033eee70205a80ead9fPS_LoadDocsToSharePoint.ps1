############################################################################################################################################
# This script allows to upload several documents to a SharePoint Document Library
# Required parameters
#   ->$siteUrl: Site Collection Url
#   ->$sDocLibraryName: Document Library where documents are going to be uploaded
############################################################################################################################################
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) 
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell }

$host.Runspace.ThreadOptions = "ReuseThread"
# Documents path
$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
$sDocsToLoadPath=$ScriptDir+ "\Docs"

#Other required variables
$sSiteUrl = “http://demo2010a:90/sites/IntranetMM/”

#Definiton of the function that uploads the documents
function Load-Documents
{
    param ($sDocLibrary,$sDocsPath)   
    try
    {
        $spSite = Get-SPSite -Identity $sSiteUrl
        $spWeb = $spSite.OpenWeb()
        
        #Verifying if the Document Library exists
        $spDocLibrary=$spWeb.Lists[$sDocLibrary]
        If (($spDocLibrary)) 
        {               
            $DocsToLoad=get-childItem $sDocsToLoadPath            
            $iNumberFiles=$DocsToLoad.Count            
            if($iNumberFiles -ne 0)
            {
                # Loading the files in the Document Library
                Write-Host "$iNumberFiles are going to be uploaded in the document library $sDocLibrary ..." -foregroundcolor Green    
                $spFileCollection = $spDocLibrary.RootFolder.Files
                #For each file to be uploaded...
                foreach ($fDoc in $DocsToLoad)
                {
                    $Stream = $fDoc.OpenRead()
                    $uploaded = $spFileCollection.Add($fDoc.Name, $Stream, $True)
                    Write-Host "File $fDoc.Name successfully uploaded" -foregroundcolor Green
                    if ($Stream) {$Stream.Dispose()}
                }

                Write-Host "-----------------------------------------"  -foregroundcolor Green
                Write-Host "Uploading process complete!!" -foregroundcolor Green
            
            }else
            {
                Write-Host "There are no files to load in the document library $sDocLibrary ..." -foregroundcolor Green    
            }
        }else
        {
            Write-Host "The document library $sDocLibrary doesn't exist ..." -foregroundcolor Red
            exit
        }        
        #Disposado de objetos
        $spWeb.Dispose()
        $spSite.Dispose()        
    }
    catch [System.Exception]
    {
        write-host -f red $_.Exception.ToString()
    }
}

Start-SPAssignment –Global
Load-Documents -sDocLibrary "Documentos compartidos"  -sDocsPath $sDocsPath
Stop-SPAssignment –Global

Remove-PSSnapin Microsoft.SharePoint.PowerShell