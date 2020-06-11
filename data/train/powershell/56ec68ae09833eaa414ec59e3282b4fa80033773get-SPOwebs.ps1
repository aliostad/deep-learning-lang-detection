# Script to get SharePoint Online tenant authentication information
$filename = "get-SPOwebs.ps1"
$version = "v1.08 updated on 02/07/2015"
# Jason Himmelstein
# http://www.sharepointlonghorn.com
# credit to Chris O'Brien, MVP for the core of this script
# Find his post at http://www.sharepointnutsandbolts.com/2013/12/Using-CSOM-in-PowerShell-scripts-with-Office365.html

# Display the profile version
Write-host "$filename $version"

. .\SPO-preload.ps1

#region functions 
function processWeb($web)
{
    $lists = $web.Lists
    $clientContext.Load($web)
    $clientContext.ExecuteQuery()
    Write-Host "Web URL is" $web.Url
}
#endregion

#region processsing 
#Iterating webs
$rootWeb = $clientContext.Web
$childWebs = $rootWeb.Webs
$clientContext.Load($childWebs)
$clientContext.ExecuteQuery()

 
foreach ($childWeb in $childWebs)
{
    processWeb($childWeb)
}
#endregion