function Get-AllExchangeServersInDomain($Domain=$null)
{
	$configNC=([ADSI]"LDAP:/$Forest/RootDse").configurationNamingContext
	$search = new-object DirectoryServices.DirectorySearcher([ADSI]"LDAP:/$Domain/$configNC")
	$search.Filter = "(&(objectClass=msExchExchangeServer)(msExchServerSite=*))"
	$search.PageSize=1000
	$search.PropertiesToLoad.Clear()
	[void] $search.PropertiesToLoad.Add("msexchcurrentserverroles")
	[void] $search.PropertiesToLoad.Add("networkaddress")
	[void] $search.PropertiesToLoad.Add("serialnumber")
	[void] $search.PropertiesToLoad.Add("versionNumber")
	[void] $search.PropertiesToLoad.Add("msExchServerSite")
	$servers = $search.FindAll()

    $Role  = @{
        2  = "Mailbox"
        4  = "Client Access Server"
        16 = "Unified Messaging"
        32 = "Hub Transport"
        64 = "Edge Transport"
    }



	foreach ($server in $servers)
	{
		#$serverName = $server.properties["networkaddress"] | where {$_.ToString().StartsWith("ncacn_ip_tcp")} | %{$_.ToString().SubString(13)}

        if ($server.properties["networkaddress"] -contains "netbios:")
        {
            $NetBiosName = $($server.properties["networkaddress"] | where {$_.ToString().StartsWith("netbios")}).replace("netbios:","")
        }

        $Roles = ($Role.Keys | Where {$_ -band $([int] $($server.properties["msexchcurrentserverroles"]))} | Foreach {$Role.Get_Item($_)}) -join ", "

        [boolean] $MailboxServer = $False
        [boolean] $CASServer = $False
        [boolean] $UMServer = $False
        [boolean] $HubServer = $False
        [boolean] $EdgeServer = $False

        switch -wildcard ($Roles)
        {
            '*Mailbox*' 
            {
                $MailboxServer = $True
            }
            '*Client Access Server*' 
            {
                $CASServer = $True
            }
            '*Unified Messaging*' 
            {
                $UMServer = $True
            }
            '*Hub Transport*' 
            {
                $HubServer = $True
            }
            '*Edge Transport*' 
            {
                $EdgeServer = $True
            }
        }
        
        $Object = New-Object PSObject -Property @{
            Name                     = $($server.properties["networkaddress"] | where {$_.ToString().StartsWith("netbios")}).replace("netbios:","")
            FQDN                     = $($server.properties["networkaddress"] | where {$_.ToString().StartsWith("ncacn_ip_tcp:")}).replace("ncacn_ip_tcp:","")
            msExchCurrentServerRoles = $server.properties["msexchcurrentserverroles"]
            ExchangeServerRoles      = $Roles <# $server.properties["msexchcurrentserverroles"] #>
            serialnumber             = $server.properties["serialnumber"][0]
            versionNumber            = $server.properties["versionNumber"]
            msExchServerSite         = $server.properties["msExchServerSite"]
            MailboxServer            = $MailboxServer
            CASServer                = $CASServer
            UMServer                 = $UMServer
            HubServer                = $HubServer
            EdgeServer               = $EdgeServer
        }
		Write-Output $Object | select Name, FQDN, msExchCurrentServerRoles, SerailNumber, versionNumber, msExchServerSite, ExchangeServerRoles, MailboxServer, CASServer, UMServer, HubServer, EdgeServer
	}
}

Get-AllExchangeServersInDomain | ft * -auto

