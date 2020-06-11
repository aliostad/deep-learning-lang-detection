#Show-ControlAccessRights.ps1

Function Show-CAR {
    Param([string]$class="user")
    
    [ADSI]$rootDSE="LDAP://RootDSE"
    [ADSI]$schemaobject="LDAP://CN=$class,"+$rootDSE.SchemaNamingContext
     
    Write-Host $schemaobject.name "control access rights" -ForegroundColor Cyan
    
    #convert to a GUID we can search with
    [system.guid]$guid=$schemaobject.SchemaIDGUID[0]
    
    #now search for objects from control access rights in schema where Appliesto=$GUID
    
    $searcher=New-Object DirectoryServices.DirectorySearcher      
    $searcher.searchroot="LDAP://CN=Extended-Rights,"+$rootDSE.ConfigurationNamingContext
    $searcher.filter="Appliesto=$guid"
    $searcher.findall() | % {
        $_ | select @{Name="Name";Expression={$_.properties.name}},
        @{Name="DisplayName";Expression={$_.properties.displayname}},
        @{Name="RightsGUID";Expression={$_.properties.rightsguid}}
        }
    
}

#sample usage
# Show-CAR "organizational-unit" 
# Show-CAR "user" | select Name,RightsGUID
# Show-CAR "computer" | select Displayname
# Show-CAR "group" | Format-Table -AutoSize
