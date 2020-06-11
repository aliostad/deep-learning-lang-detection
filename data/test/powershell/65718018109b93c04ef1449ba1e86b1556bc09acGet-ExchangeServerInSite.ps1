Function Get-ExchangeServerInSite {
    $ADSite = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]
    $siteDN = $ADSite::GetComputerSite().GetDirectoryEntry().distinguishedName
    $configNC=([ADSI]"LDAP://RootDse").configurationNamingContext
    $search = new-object DirectoryServices.DirectorySearcher([ADSI]"LDAP://$configNC")
    $objectClass = "objectClass=msExchExchangeServer"
    $version = "versionNumber>=1937801568"
    $site = "msExchServerSite=$siteDN"
    $search.Filter = "(&($objectClass)($version)($site))"
    $search.PageSize=1000
    [void] $search.PropertiesToLoad.Add("name")
    [void] $search.PropertiesToLoad.Add("msexchcurrentserverroles")
    [void] $search.PropertiesToLoad.Add("networkaddress")
    $search.FindAll() | %{
      $pso =   New-Object PSObject -Property @{
            Name = $_.Properties.name[0]
            FQDN = $_.Properties.networkaddress |
                %{if ($_ -match "ncacn_ip_tcp") {$_.split(":")[1]}}
            Roles = $_.Properties.msexchcurrentserverroles[0]
        }
       
    }
     Write-Output $pso
}