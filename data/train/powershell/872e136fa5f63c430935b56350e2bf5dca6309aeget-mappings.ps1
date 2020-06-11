cls

$ldaps = @('LDAP://host1:389/OU=Users,DC=company,DC=internal,DC=corp', 'LDAP://imb:389/OU=Employes,OU=Department,DC=company,DC=internal,DC=corp')

$ldaps | % {
    $ldapUrl = $_

    $objDomain = New-Object System.DirectoryServices.DirectoryEntry($ldapUrl)

    $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
    $objSearcher.SearchRoot = $objDomain
    $objSearcher.PageSize = 1000
    $objSearcher.Filter = "(&(objectClass=user)(mail=*@company.com*))"
    $objSearcher.SearchScope = "Subtree"

    $objSearcher.PropertiesToLoad.Add("cn") > $null
    $objSearcher.PropertiesToLoad.Add("mail") > $null
    $objSearcher.PropertiesToLoad.Add("samaccountname") > $null

    $colResults = $objSearcher.FindAll()

    foreach ($objResult in $colResults) {
        $objItem = $objResult.Properties;
        $objItem.samaccountname.Trim() + "`t" + ($objItem.mail.Trim() -ireplace '@.*$', '')
    }
}
