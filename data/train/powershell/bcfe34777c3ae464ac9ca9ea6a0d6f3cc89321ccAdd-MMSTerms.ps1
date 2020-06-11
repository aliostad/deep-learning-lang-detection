#Specify tenant admin and URL
$User = ""
$TenantURL = ""
$Site = ""
$GroupName = "Group"
$TermSetName = "Term Set"
$Terms = Get-Content "C:\terms.txt"

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

#Bind to Group
$Group = $TermStore.Groups.GetByName($GroupName)
$Context.Load($Group)
$Context.ExecuteQuery()

#Bind to Term Set
$TermSet = $Group.TermSets.GetByName($TermSetName)
$Context.Load($TermSet)
$Context.ExecuteQuery()

Foreach ($Term in $Terms)
    {
    $TermAdd = $TermSet.CreateTerm($Term,1033,[System.Guid]::NewGuid().toString())
    $Context.Load($TermAdd)
    $Context.ExecuteQuery()
    }
