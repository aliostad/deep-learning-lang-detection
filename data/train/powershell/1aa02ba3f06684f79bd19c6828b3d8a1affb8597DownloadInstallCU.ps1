
# Import Required Modules
Import-Module BitsTransfer 


# Specify download url's for SharePoint 2013 prerequisites
$DownloadUrls = (
		    "http://download.microsoft.com/download/5/1/C/51CA768E-C79E-41BA-91D4-7F7D929B0BFE/ubersrvsp2013-kb2767999-fullfile-x64-glb.exe" # Microsoft Sharepoint Server 2013 March Cumulative Update
		   
                ) 


function DownLoadCU() 
{ 

    Write-Host ""
    Write-Host "====================================================================="
    Write-Host "      Downloading SharePoint 2013 CU Please wait..." 
    Write-Host "====================================================================="
     
    $ReturnCode = 0 
 
    foreach ($DownLoadUrl in $DownloadUrls) 
    { 
        ## Get the file name based on the portion of the URL after the last slash 
        $FileName = $DownLoadUrl.Split('/')[-1] 
        Try 
        { 
            ## Check if destination file already exists 
            If (!(Test-Path " C:\CU\$FileName")) 
            { 
                ## Begin download 
                Start-BitsTransfer -Source $DownLoadUrl -Destination C:\CU\$fileName -DisplayName "Downloading `'$FileName`' to C:\CU" -Priority High -Description "From $DownLoadUrl..." -ErrorVariable err 
                If ($err) {Throw ""} 
            } 
            Else 
            { 
                Write-Host " - File $FileName already exists, skipping..." 
            } 
        } 
        Catch 
        { 
            $ReturnCode = -1 
            Write-Warning " - An error occurred downloading `'$FileName`'" 
            Write-Error $_ 
            break 
        } 
    } 
    Write-Host " - Done downloading CU required for SharePoint 2013" 
     
    return $ReturnCode 
} 


 

function CheckProvidedDownloadPath()
{


    $ReturnCode = 0

    Try 
    { 
        # Check if destination path exists 
        If (Test-Path C:\CU) 
        { 
           # Remove trailing slash if it is present
           
	   $ReturnCode = 0
        }
        Else {

	   $ReturnCode = -1
           Write-Host ""
	   Write-Warning "Your specified download path does not exist. Please verify your download path then run this script again."
           Write-Host ""
        } 


    } 
    Catch 
    { 
         $ReturnCode = -1 
         Write-Warning "An error has occurred when checking your specified download path" 
         Write-Error $_ 
         break 
    }     
    
    return $ReturnCode 

}


 
function DownloadCUs() 
{ 

    $rc = 0 
    
    $rc = CheckProvidedDownloadPath  

    # Download Pre-Reqs  
    if($rc -ne -1) 
    { 
        $rc = DownloadCU 
    } 
     

    if($rc -ne -1)
    {

        Write-Host ""
        Write-Host "Script execution is now complete!"
        Write-Host ""
    }


} 
Set-ExecutionPolicy Unrestricted -Force
md c:\CU
DownloadCUs
cd C:\CU
.\ubersrvsp2013-kb2767999-fullfile-x64-glb.exe /i
