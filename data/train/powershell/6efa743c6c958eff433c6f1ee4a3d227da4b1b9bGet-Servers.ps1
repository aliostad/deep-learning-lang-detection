# rework needed!
<#
.DESCRIPTION
    Get a list of servers from the current Active Directory domain
#>
function Get-Servers {
    $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
    $objSearcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry
    $objSearcher.Filter = ("OperatingSystem=Window*Server*")
    $objSearcher.PropertiesToLoad.Add("name") | Out-Null
    $colResults = $objSearcher.FindAll()
    
    foreach ($objResult in $colResults) {
        $objResult.Properties.name 
    }
}
