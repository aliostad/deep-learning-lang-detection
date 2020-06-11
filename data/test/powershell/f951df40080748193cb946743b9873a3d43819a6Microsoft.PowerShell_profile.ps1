#PowerShell Profiles to be used
$filename = "Microsoft.PowerShell_profile.ps1"
$version = "v4.22 updated on 02/08/2015"
#Jason Himmelstein
#http://www.sharepointlonghorn.com

#Display the profile version
Write-host "$filename $version" -BackgroundColor Black -ForegroundColor Yellow
""

#region functions  
function get-cloudy
{
$AZLoad = Read-Host "Do you wish to load your Azure Accounts? Type [y] to load" 
if ($AZLoad -eq "y"){$AZLoaded = add-AzureAccount}

If($AZLoad -eq "y")
{
$xml = (Get-Content -raw -path "C:\Users\$env:username\AppData\Roaming\Windows Azure Powershell\AzureProfile.json") | ConvertFrom-Json
$xsub = $xml.Subscriptions | Select-Object name | out-gridview -outputmode Single -title "Azure Subscriptions"
Select-AzureSubscription -SubscriptionName $xsub.name
}

If($AZLoad -eq "y")
{
# Get the Cloud Service Name
Write-Host "Pick your Cloud Service" -ForegroundColor Blue -BackgroundColor Gray
$ACS = Get-AzureService | Select-Object ServiceName,affinitygroup,status | out-gridview -outputmode Single -title "Connect to a cloud service"
}

If($AZLoad -eq "y")
{
# Get the VMs from the cloud service
Write-host "These VMs are available in this Cloud Service:"
Get-AzureVM | fl name,status
}
}

function get-o365
{
try{
    $o365Load = Read-Host "Do you wish to connect to Office 365? Type [y] to load" 
    if ($o365Load -eq "y"){. .\set-o365connection.ps1}
}
catch
{
    Write-host "Failed to load set-o365Conection.ps1. Check the file location in your PowerShell Profile" -ForegroundColor Red

    #to get verbose logging uncomment the following line
    #write-host "$_" -BackgroundColor Black -ForegroundColor Red 
}
}

function get-SPO
{
try{
    $SPOLoad = Read-Host "Do you wish to connect to SharePoint Online? Type [y] to load" 
    if ($SPOLoad -eq "y"){. .\set-SPOconnection.ps1}
}
catch
{
    Write-host "Failed to load set-SPOConection.ps1. Check the file location in your PowerShell Profile" -ForegroundColor Red

    #to get verbose logging uncomment the following line
    #write-host "$_" -BackgroundColor Black -ForegroundColor Red 
}
}

#endregion

# Setting the default starting path
Set-Location c:\powershellscripts\

#region permissions check
if ( -not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{ 
    Write-Host "This PowerShell prompt is not elevated" -ForegroundColor Red -BackgroundColor black
    Write-Host "If you are trying to effect change to a SharePoint environment you need to be running PowerShell as Administrator. 
Please restart PowerShell as with the administrator token set." -ForegroundColor Yellow -BackgroundColor black
    return
}
#endregion

#region logging
# set logging
$path = "C:\PowerShellLogs"
$logname = "{0}\{1}-{2}.{3}" -f $path,$env:Username, `
    (Get-Date -Format MMddyyyy-HHmmss),"Txt"
# Start Transcript in logs directory
start-transcript (New-Item -Path $logname -ItemType file) -append -noclobber
 $a = Get-Date
“Date: ” + $a.ToShortDateString()
“Time: ” + $a.ToShortTimeString() 
#endregion 

#region imports
#loading snap-ins & modules
""
Write-Host "Please wait while the PowerShell snap-ins load" -foregroundcolor black -backgroundcolor gray
Add-PSSnapin Microsoft.SharePoint.PowerShell -ea 0
Add-PSSnapin Microsoft.Windows.AD -ea 0
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
""
Write-Host "The following PowerShell Snap-ins are loaded:" -foregroundcolor darkgreen -backgroundcolor gray
get-pssnapin
Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1' -ErrorAction SilentlyContinue
Import-Module 'C:\Program Files\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.Online.SharePoint.PowerShell.psd1' -ErrorAction SilentlyContinue
""
Write-Host "The following PowerShell Modules are loaded:" -foregroundcolor DarkGreen -BackgroundColor Gray
get-module | ft Name | out-default
#endregion

#region CSOM
# Loading the CSOM references from add-CSOMreferencelibraries
try{
    ""
    Write-Host "Attempting to load CSOM Reference Libraries"
    . .\add-CSOMreferencelibraries.ps1 -ea 0
    ""
}
catch{
    Write-host "Failed to load add-CSOMreferencelibraries.ps1. Check the file location in your PowerShell Profile" -ForegroundColor Red
    Write-Host "Error: $_" -BackgroundColor Black -ForegroundColor Red 
    ""
}
#endregion

Write-Host "You are now entering PowerShell in the context of: $env:USERDOMAIN\$env:Username" -foregroundcolor darkgreen -backgroundcolor gray

# load additional modules with authentication 
get-cloudy
get-o365
get-SPO