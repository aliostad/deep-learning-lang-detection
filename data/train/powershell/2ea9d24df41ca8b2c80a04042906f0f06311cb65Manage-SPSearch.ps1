<#
.Link Create a Search Topology in SharePoint 2013
    http://blogs.technet.com/b/pfelatam/archive/2013/05/10/create-a-search-topology-in-sharepoint-2013.aspx
.Link Manage search components in SharePoint Server 2013v
    http://technet.microsoft.com/en-us/library/jj862354.aspx
#>

<#
GetOrStartSearchServiceInstance

The following function help us to check if the search service instance is started in a specific sever and retrieve the reference to it, or start the service instances in the case that is wasn’t started.

.Example
    MaybeStart-SPSearchServiceInstance -Server “<server name>”
#>
function MaybeStart-SPSearchServiceInstance($Server)
{
    $startInstance = $false
    $serverIns = Get-SPEnterpriseSearchServiceInstance -Identity $Server
    if($serverIns -ne $null)
    {
        if($serverIns.Status -ne "Online")
        {
            $startInstance = $true
        }
    }
    else
    {
        $startInstance = $true
    }
    if($startInstance)
    {
        $serverIns = Start-SPEnterpriseSearchServiceInstance -Identity $serverIns
    }
    return $serverIns
}

<#
Set-SPSearchComponents

This functions needs the following parameters:

ServerType: Is a string that define the component to add or remove, can be: Admin, AnalyticsProcessing, ContentProcessing, Crawl or QueryProcessing.
ServersStringArray: The servers that you want to use to host the specific search component.  This servers must be separated by coma, for example: “server1,server2,server3”.
Topology: The reference to the Search topology that you want to modify to add or remove the componets.


Set-SPSearchComponents -ServerType "AnalyticsProcessing" -ServersStringArray “server1,server3” -Topology $newTop
#>
function Set-SPSearchComponents($ServerType, $ServersStringArray, $Topology)
{
    #Check if is a valid type of search component
    $validTypes = ("Admin", "AnalyticsProcessing", "ContentProcessing", "Crawl", "QueryProcessing")
    if($validTypes.Contains($ServerType) -ne $true)
    {
        throw "ServerType is not valid."
    }
    #Check server by server is need to Remove or Add
    $ServerType += "Component"
    $currentServers = Get-SPEnterpriseSearchComponent -SearchTopology $Topology | ?{$_.GetType().Name -eq $ServerType}
    #Remove components
    foreach($component in $currentServers)
    {       
        Remove-SPEnterpriseSearchComponent -Identity $component -SearchTopology $Topology #-Confirm $true    
    }
    #Add Components
    foreach($server in $ServersStringArray.Split(","))
    {
        #Check in search service instance is started, otherwise start it
        $serIns = GetOrStartSearchServiceInstance -Server $server       
        switch($ServerType)
        {
            "AdminComponent" {New-SPEnterpriseSearchAdminComponent -SearchTopology $newTop -SearchServiceInstance $serIns}
            "AnalyticsProcessingComponent" {New-SPEnterpriseSearchAnalyticsProcessingComponent -SearchTopology $newTop -SearchServiceInstance $serIns}
            "ContentProcessingComponent" {New-SPEnterpriseSearchContentProcessingComponent -SearchTopology $newTop -SearchServiceInstance $serIns}
            "CrawlComponent" {New-SPEnterpriseSearchCrawlComponent -SearchTopology $newTop -SearchServiceInstance $serIns}
            "QueryProcessingComponent" {New-SPEnterpriseSearchQueryProcessingComponent -SearchTopology $newTop -SearchServiceInstance $serIns}
        }
    }
    #Show in the output the search components of the topology to see the modificatios made on.
    Get-SPEnterpriseSearchComponent -SearchTopology $Topology
}

<#
New-SPSearchTopology

To use this function must to pass the following parameters:

AdminServers: The servers that you want to use to host the Admin search component.  This servers must be separated by coma, for example: “server1,server2,server3”.
AnalyticsServers: The servers that you want to use to host the Analytics Processing search component.  This servers must be separated by coma, for example: “server1,server2,server3”.
ContentServers: The servers that you want to use to host the Content Processing search component.  This servers must be separated by coma, for example: “server1,server2,server3”.
CrawlServers: The servers that you want to use to host the Crawl search component.  This servers must be separated by coma, for example: “server1,server2,server3”.
QueryServers: The servers that you want to use to host the Query search component.  This servers must be separated by coma, for example: “server1,server2,server3”.
.Example
    New-SPSearchTopology –AdminServers “server1,server2” –AnalyticsServers “server1,server3” –ContentServers “server2,server4” –CrawlServers “server5,server6” –QueryServers “server7,server8,server9”
#>
function New-SPSearchTopology($AdminServers, $AnalyticsServers, $ContentServers, $CrawlServers, $QueryServers)
{
    $servers = $AdminServers + "," + $AnalyticsServers + "," + $ContentServers + "," + $CrawlServers + "," + $QueryServers
    #Check the existence of the servers
    foreach($server in $servers.Split(","))
    {
        Get-SPServer $server -ErrorAction Stop
    }
    #Initialize variables
    $ssa = Get-SPEnterpriseSearchServiceApplication
    #Clone search topology
    $activeTop = Get-SPEnterpriseSearchTopology -SearchApplication $ssa -Active
    $newTop = New-SPEnterpriseSearchTopology -SearchApplication $ssa -Clone –SearchTopology $activeTop
    #Admin component
    Set-SPSearchComponents -ServerType "Admin" -ServersStringArray $AdminServers -Topology $newTop
    #Analytics servers
    Set-SPSearchComponents -ServerType "AnalyticsProcessing" -ServersStringArray $AnalyticsServers -Topology $newTop
    #Content
    Set-SPSearchComponents -ServerType "ContentProcessing" -ServersStringArray $AnalyticsServers -Topology $newTop
    #Crawl
    Set-SPSearchComponents -ServerType "Crawl" -ServersStringArray $AnalyticsServers -Topology $newTop
    #Query
    Set-SPSearchComponents -ServerType "QueryProcessing" -ServersStringArray $AnalyticsServers -Topology $newTop
    #Active Topology
    Set-SPEnterpriseSearchTopology -Identity $newTop
}