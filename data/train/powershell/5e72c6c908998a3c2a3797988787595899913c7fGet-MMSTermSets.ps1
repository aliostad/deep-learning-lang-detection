#Specify tenant admin and URL
$User = ""
$TenantURL = ""
$Site = ""

#Add references to SharePoint client assemblies and authenticate to Office 365 site - required for CSOM
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Taxonomy.dll"
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString

#Bind to MMS
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($Site)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)
$Context.Credentials = $Creds
$MMS = [Microsoft.SharePoint.Client.Taxonomy.TaxonomySession]::GetTaxonomySession($Context)
$Context.Load($MMS)
$Context.ExecuteQuery()

#Retrieve Term Stores
$TermStores = $MMS.TermStores
$Context.Load($TermStores)
$Context.ExecuteQuery()

#Bind to Term Store
$TermStore = $TermStores[0]
$Context.Load($TermStore)
$Context.ExecuteQuery()

#Retrieve Groups
$Groups = $TermStore.Groups
$Context.Load($Groups)
$Context.ExecuteQuery()

#Retrieve TermSets in each group
Foreach ($Group in $Groups)
    {
    $Context.Load($Group)
    $Context.ExecuteQuery()
    Write-Host "Group Name:" $Group.Name -ForegroundColor Green
    $TermSets = $Group.TermSets
    $Context.Load($TermSets)
    $Context.ExecuteQuery()
    Foreach ($TermSet in $TermSets)
        {
        Write-Host "      Term Set Name:"$TermSet.Name -ForegroundColor Yellow
        Write-Host "        Terms:" -ForegroundColor DarkCyan
        $Terms = $TermSet.Terms
        $Context.Load($Terms)
        $Context.ExecuteQuery()
        Foreach ($Term in $Terms)
            {
            Write-Host "            " $Term.Name -ForegroundColor White
            }
        }
    }