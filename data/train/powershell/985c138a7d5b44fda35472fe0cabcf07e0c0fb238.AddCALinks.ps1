Add-PSSnapin Microsoft.SharePoint.Powershell -EA 0 

#Get the URL to Central Administration
$caUrl = Get-spwebapplication -includecentraladministration | where {$_.IsAdministrationWebApplication} | select Url -First 1
#Filter the Service Apps by those we want links
$apps = Get-SPServiceApplication | ?{($_.TypeName -eq "User Profile Service Application") `
                                 -or ($_.TypeName -eq "Managed Metadata Service") `
                                 -or ($_.TypeName -eq "Business Data Connectivity Service Application") `
                                 -or ($_.TypeName -eq "Usage and Health Data Collection Service Application") `
                                 -or ($_.TypeName -eq "Search Service Application")}

#Start our assignment for the web object
$spAssignment = Start-SPAssignment
#Grab our list in Central Admin
$list = (Get-SPWeb -identity $caUrl.Url -AssignmentCollection $spAssignment).Lists["Resources"]
#Enumerate the list and create links to each
foreach ($app in $apps)
{
    Write-Host "Adding" $app.DisplayName
    $item = $list.Items.Add()
    $item["URL"] = "$($app.ManageLink.Url), $($app.DisplayName)"
    $item["Comments"] = "Added for fun. And profit."
    $item.Update()
}

#Dispose of the list
Stop-SPAssignment $spAssignment
