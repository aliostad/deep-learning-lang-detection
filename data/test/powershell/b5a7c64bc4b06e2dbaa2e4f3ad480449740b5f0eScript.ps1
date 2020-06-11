$limit = (Get-Date).AddDays(-1)
$path = "C:\TeamCity\buildAgent\work\e893f1f054c12535\AngularJSAuthentication.API\bin"
$pathOctopusAPI = "C:\Octopus\Applications\local.web\Local Web Server\AngularJSAuthentication.API"
$pathOctopusWeb = "C:\Octopus\Applications\local.web\Local Web Server\AngularJSAuthentication.Web"

$pathOctopusWebOldPackages = "C:\Octopus\local.web\Files"



# Delete files older than the $limit.
# Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

get-childitem -Path $path -include *.nupkg -recurse | foreach ($_) {remove-item $_.fullname}


Remove-Item -Recurse -Force $pathOctopusAPI
Remove-Item -Recurse -Force $pathOctopusWeb

Remove-Item -Recurse -Force $pathOctopusWebOldPackages