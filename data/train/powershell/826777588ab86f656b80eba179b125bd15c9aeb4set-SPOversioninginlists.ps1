# Script to get SharePoint Online tenant authentication information
$filename = "get-SPOListWebsandUpdateVersioning.ps1"
$version = "v1.04 updated on 02/07/2015 foo"
# Jason Himmelstein
# http://www.sharepointlonghorn.com
# credit to Chris O'Brien, MVP for the core of this script
# Find his post at http://www.sharepointnutsandbolts.com/2013/12/Using-CSOM-in-PowerShell-scripts-with-Office365.html

# Display the profile version
Write-host "$filename $version"

. .\SPO-preload.ps1
 
#Iterating webs, then lists, and updating a property on each list
$enableVersioning = $true
 
$rootWeb = $clientContext.Web
$childWebs = $rootWeb.Webs
$clientContext.Load($rootWeb)
$clientContext.Load($childWebs)
$clientContext.ExecuteQuery()
 
function processWeb($web)
{
    $lists = $web.Lists
    $clientContext.Load($web)
    $clientContext.Load($lists)
    $clientContext.ExecuteQuery()
    Write-Host "Processing web with URL " $web.Url
 
    foreach ($list in $web.Lists)
    {
        Write-Host "-- " $list.Title
 
        # leave the "Master Page Gallery" and "Site Pages" lists alone, since these have versioning enabled by default..
        if ($list.Title -ne "Master Page Gallery" -and $list.Title -ne "Site Pages")
        {
            Write-Host "---- Versioning enabled: " $list.EnableVersioning
            $list.EnableVersioning = $enableVersioning
            $list.Update()
            $clientContext.Load($list)
            $clientContext.ExecuteQuery()
            Write-Host "---- Versioning now enabled: " $list.EnableVersioning
        }
    }
}
 
foreach ($childWeb in $childWebs)
{
    processWeb($childWeb)
}