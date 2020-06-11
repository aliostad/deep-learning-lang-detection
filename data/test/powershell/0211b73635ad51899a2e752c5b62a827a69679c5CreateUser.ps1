#SetupUser.ps1-v3(forked)

#---------------------------------------------------------------------------------
# Parameters
#---------------------------------------------------------------------------------
param(
    [string]$siteUrl = $(throw "please specify the url of a SharePoint site to open!"),
    [string]$mySiteHostUrl = $(throw "please specify the url of MySite Host!"),
    [System.Collections.Specialized.StringDictionary]$data = $(throw "please specify a data dictionary!")
)

#---------------------------------------------------------------------------------
# Default Values
#---------------------------------------------------------------------------------

$userFullName = "Unknown";
$spNotFoundMsg = "Unable to connect to SharePoint.  Please verify that the site '$siteUrl' is hosted on the local machine.";

#---------------------------------------------------------------------------------
# Load Assemblies
#---------------------------------------------------------------------------------

if ([Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") -eq $null)		{ throw $spNotFoundMsg; }
if ([Reflection.Assembly]::LoadWithPartialName("Microsoft.Office.Server") -eq $null)	{ throw $spNotFoundMsg; }
[void] [Reflection.Assembly]::LoadWithPartialName("System.Web")
. .\SPUtils.ps1


#---------------------------------------------------------------------------------
# Process the passed in data
#---------------------------------------------------------------------------------

""
([System.String]::Empty.PadRight(20, "-"))

$userFullName = ($data["LastName"] + ([string]", ") + $data["FirstName"]);
([string]"Operating against user: $userFullName.  With login name: " + $data["AccountName"])

$username = ($data["AccountName"] -replace "$env:COMPUTERNAME\\", "")
$computer = [ADSI]"WinNT://$env:COMPUTERNAME"
$user = $computer.Create("User", $username)
$user.SetPassword("=[;.-pl,0okm")
$user.SetInfo()


$user.FullName = $userFullName
$user.Description = $data["AboutMe"]
$user.userflags = 0x10000 #Set password to never expire
$user.SetInfo()

#Add the account to the local users group
$group = [ADSI]"WinNT://$env:COMPUTERNAME/Users,group"
$group.add("WinNT://$env:COMPUTERNAME/$username")

