param(
    [parameter(Mandatory=$true)]
    [string]$SiteUrl,
   
    [parameter(Mandatory=$true)]
    [string]$UserName,

    [parameter(Mandatory=$true)]
    [string]$Password
)

#############FUNCTIONS###############
function Write-ToLogFile
{
    
    param(
        [Parameter(Mandatory=$true)] 
        [ValidateNotNullOrEmpty()] 
        [string]$Message,
        
        [Parameter(Mandatory=$true)] 
        [string]$Path,
          
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info",

        [switch]
        $ConsoleOut
    )
    Begin 
    { 
    } 
    Process 
    {         
        if (!(Test-Path $Path)) 
        { 
            New-Item $Path -Force -ItemType File|Out-Null
        } 
        
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
        switch ($Level) { 
            'Error' {  
                $LevelText = 'ERROR:'
                $ForgroundCol = 'Red' 
                } 
            'Warn' {  
                $LevelText = 'WARNING:'
                $ForgroundCol = 'Yellow' 
                } 
            'Info' {  
                $LevelText = 'INFO:'
                $ForgroundCol = 'White' 
                } 
            }
        
        $OutputLine = "$FormattedDate $LevelText $Message"
        if($ConsoleOut) 
        {
            Write-Host  $Message -ForegroundColor $ForgroundCol    
        }
        $OutputLine| Out-File -FilePath $Path -Append
    } 
    End 
    {
     
    } 
}

function Export-ToCsvFile
{
    param(
        [Object[]]$ListToExport,
        $CsvFileName
    )

   if($ListToExport.Count -gt 0)
   {
     $CurrentDir = Split-Path -parent $script:MyInvocation.MyCommand.Path
     $SaveDir = $CurrentDir+"\Output"
     if(!(Test-Path $SaveDir))
     {
        New-Item -ItemType Directory -Force -Path $SaveDir|Out-Null
     }
                    
     $OutputFileName = $CsvFileName +".csv"
     $OutputFilePath = $SaveDir+"\"+$OutputFileName        
     if (Test-Path $OutputFilePath)
     {
        Remove-Item $OutputFilePath
     }
             
     $ListToExport|Export-Csv $OutputFilePath -NoTypeInformation
     Write-Host          
     Write-Host "File saved to: $OutputFilePath"
   }
}



#############MAIN###############
Write-Host
Write-Host "Current script version - #1" -ForegroundColor Green -BackgroundColor Black
$StartTime=Get-Date
Write-Host
Write-Host "Script started at $($StartTime)"
$sw = [Diagnostics.Stopwatch]::StartNew()

$Dir = Split-Path -parent $MyInvocation.MyCommand.Path
$DllsDir = $Dir+"\DLL"
$FormattedDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFilePath = $Dir+"\RunLog_$($FormattedDate).log"

Write-ToLogFile -Message "Current script version - #1" -Path $LogFilePath -Level Info
Write-ToLogFile -Message "Script started at $($StartTime)" -Path $LogFilePath -Level Info
Write-Host

Write-ToLogFile -Message "Loading SPO module and client dlls" -Path $LogFilePath -Level Info -ConsoleOut
try
{
    Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
    Add-Type –Path "$($DllsDir)\Microsoft.SharePoint.Client.dll" 
    Add-Type –Path "$($DllsDir)\Microsoft.SharePoint.Client.Runtime.dll"
    Write-ToLogFile -Message "Done!" -Path $LogFilePath -Level Info -ConsoleOut    
}
catch
{
    Write-ToLogFile -Message "Caught an exception while loading modules:" -Path $LogFilePath -Level Error -ConsoleOut
    Write-ToLogFile -Message "Exception Type: $($_.Exception.GetType().FullName)" -Path $LogFilePath -Level Error -ConsoleOut
    Write-ToLogFile -Message "Exception Message: $($_.Exception.Message)" -Path $LogFilePath -Level Error -ConsoleOut
    return      
}


$match=$SiteUrl -match "https://\w+."
$AdminSiteUrl = ($Matches[0]).Replace(".","-admin.")+"sharepoint.com"

$Creds = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $(convertto-securestring $Password -asplaintext -force)
$SecurePassword = New-Object System.Security.SecureString
$SecureArray = $Password.ToCharArray()
foreach ($char in $SecureArray)
{
    $SecurePassword.AppendChar($char)
}

$SPOCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $SecurePassword)

Write-Host
Write-ToLogFile -Message "Connecting to SPO admin service $($AdminSiteUrl)..." -Path $LogFilePath -Level Info -ConsoleOut
try
{
    Connect-SPOService -Url $AdminSiteUrl -Credential $Creds
    Write-ToLogFile -Message "Done!" -Path $LogFilePath -Level Info -ConsoleOut
}
catch
{
        
  Write-ToLogFile -Message "Caught an exception connection to SPO:" -Path $LogFilePath -Level Error -ConsoleOut
  Write-ToLogFile -Message "Exception Type: $($_.Exception.GetType().FullName)" -Path $LogFilePath -Level Error -ConsoleOut
  Write-ToLogFile -Message "Exception Message: $($_.Exception.Message)" -Path $LogFilePath -Level Error -ConsoleOut
}

Write-ToLogFile -Message "Loading all sites" -Path $LogFilePath -Level Info -ConsoleOut

try
{
    $sites = Get-SPOSite -Limit All
    Write-ToLogFile -Message "Done!" -Path $LogFilePath -Level Info -ConsoleOut   
}
catch
{    
    Write-ToLogFile -Message "Caught an exception while loading sites:" -Path $LogFilePath -Level Error -ConsoleOut
    Write-ToLogFile -Message "Exception Type: $($_.Exception.GetType().FullName)" -Path $LogFilePath -Level Error -ConsoleOut
    Write-ToLogFile -Message "Exception Message: $($_.Exception.Message)" -Path $LogFilePath -Level Error -ConsoleOut   
}

$webs = @()
Write-ToLogFile -Message "Checking root webs" -Path $LogFilePath -Level Info -ConsoleOut
foreach ($site in $sites)
{
    Write-ToLogFile -Message "Processing web: $($site.Url)" -Path $LogFilePath -Level Info
    $surl = $site.Url
    $context = New-Object Microsoft.SharePoint.Client.ClientContext($surl)  
    $context.Credentials = $SPOCredentials
    [Microsoft.SharePoint.Client.Web]$web = $context.Web
    $context.Load($web)
    $context.ExecuteQuery()
    
    $masterPageCatalogs = @()
    $catalogList = $web.GetCatalog([Microsoft.SharePoint.Client.ListTemplateType]::MasterPageCatalog)    
    $context.Load($catalogList.RootFolder.Folders)
    $context.ExecuteQuery()
    for ($i = $catalogList.RootFolder.Folders.Count-1; $i -ge 0; $i--)
    {
        $masterPageCatalogs += $catalogList.RootFolder.Folders[$i].Name      
    }
    $customFolders = @()
    $customFolders = $masterPageCatalogs|Where-Object {$_ -like 'CustomDesign*'}
    if($web.MasterUrl -match 'CustomDesign*')
    {
        $CustomTheme = 'Y'
    }
    elseif ($null -ne $customFolders)
    {
         $CustomTheme = 'Y'
    }
    else { $CustomTheme = 'N'}
    Write-ToLogFile -Message "   MasterUrl: $($web.MasterUrl)" -Path $LogFilePath -Level Info
    Write-ToLogFile -Message "   CustomMasterUrl: $($web.CustomMasterUrl)" -Path $LogFilePath -Level Info
    Write-ToLogFile -Message "   MasterPageCatalogs: $($masterPageCatalogs)" -Path $LogFilePath -Level Info
    Write-ToLogFile -Message "   CustomTheme: $CustomTheme" -Path $LogFilePath -Level Info
    $webs += New-Object PSObject -Property @{
                WebUrl = $web.Url
                WebName = $web.Title
                CustomTheme =  $CustomTheme               
                MasterUrl = $web.MasterUrl                
                CustomMasterUrl = $web.CustomMasterUrl
                AlternateCssUrl = $web.AlternateCssUrl
                MasterPageCatalogs = $masterPageCatalogs                
    }
}
Write-ToLogFile -Message "Done!" -Path $LogFilePath -Level Info -ConsoleOut
if($webs.Count -gt 0)
{
    Write-ToLogFile -Message "Printing results:" -Path $LogFilePath -Level Info -ConsoleOut   
    $webs|Select-Object -Property WebUrl,CustomTheme|Format-Table -AutoSize -Wrap    
    Export-ToCsvFile -ListToExport $webs -CsvFileName "WebsWithCustomThemes"
    Write-ToLogFile -Message "Exported $($webs.Count) list(s) to $($Dir)\Output\WebsWithCustomThemes.csv" -Path $LogFilePath -Level Info
}
$sw.Stop()
Write-Host "Total execution time: $($sw.Elapsed.Hours) hours $($sw.Elapsed.Minutes) min $($sw.Elapsed.Seconds) sec"
$FinishDate=Get-Date
Write-Host "Script finished at $($FinishDate)"
Write-Host "Done!" -ForegroundColor Green

Write-ToLogFile -Message "Total execution time: $($sw.Elapsed.Hours) hours $($sw.Elapsed.Minutes) min $($sw.Elapsed.Seconds) sec" -Path $LogFilePath -Level Info
Write-ToLogFile -Message "Script finished at $($FinishDate)" -Path $LogFilePath -Level Info
Write-ToLogFile -Message "Done!" -Path $LogFilePath -Level Info

