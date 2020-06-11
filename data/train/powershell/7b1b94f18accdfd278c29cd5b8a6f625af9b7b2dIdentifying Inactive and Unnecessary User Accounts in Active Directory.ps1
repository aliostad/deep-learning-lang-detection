$Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$ADSearch = New-Object System.DirectoryServices.DirectorySearcher
$ADSearch.PageSize = 100
$ADSearch.SearchScope = "subtree"
$ADSearch.SearchRoot = "LDAP://$Domain"

$ADSearch.Filter = "(&(objectclass=user)(objectcategory=person))"

$ADSearch.PropertiesToLoad.Add("distinguishedName")
$ADSearch.PropertiesToLoad.Add("sAMAccountName")
$ADSearch.PropertiesToLoad.Add("lastLogonTimeStamp")

$userObjects = $ADSearch.FindAll()
$Users = @()
foreach ($user in $userObjects)
{
 $dn = $user.Properties.Item("distinguishedName")
 $sam = $user.Properties.Item("sAMAccountName")
 $logon = $user.Properties.Item("lastLogonTimeStamp")
 if($logon.Count -eq 0)
     {
         $lastLogon = "Never"
     }
 else
     {
         $lastLogon = [DateTime]$logon[0]
         $lastLogon = $lastLogon.AddYears(1600)
     }
     
$props =  @{'DistinguishedName'=$dn;
            'sAMAccountName'=$sam;
            'lastLogon'=$lastLogon}
        
$obj = New-Object -TypeName PSObject -Property $props  
$Users += $obj
Write-Output  $obj     

}