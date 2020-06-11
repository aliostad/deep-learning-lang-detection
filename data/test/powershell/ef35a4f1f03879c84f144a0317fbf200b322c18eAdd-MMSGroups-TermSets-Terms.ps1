#Specify tenant admin and URL
$User = ""
$TenantURL = ""
$Site = ""
[XML]$Import = Get-Content "C:\Example.xml"

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

Foreach ($GroupName in $Import.Groups.Group)
{
#Create Groups
$Group = $TermStore.CreateGroup($GroupName.Name,[System.Guid]::NewGuid().toString())
$Context.Load($Group)
$Context.ExecuteQuery()
    Foreach ($TermSetName in $GroupName.TermSets)
        {
        #Create Term Sets
        $TermSet = $Group.CreateTermSet($TermSetName.Name,[System.Guid]::NewGuid().toString(),1033)
        $Context.Load($TermSet)
        $Context.ExecuteQuery()
        Foreach ($TermName in $TermSetName.Terms.Term)
            {
            #Create Terms
            $TermAdd = $TermSet.CreateTerm($TermName,1033,[System.Guid]::NewGuid().toString())
            $Context.Load($TermAdd)
            $Context.ExecuteQuery()
            }
        }
}
