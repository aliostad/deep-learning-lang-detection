$cleanPath = "c:\student\demos"

# show all Visual Studio generated folders - these aren't necessary as they are rebuilt by VS on each build/deploy/package action
$cleanTargets = Get-ChildItem -Path $cleanPath -Recurse | 
    Where-Object {$_.psIsContainer -eq $true} | 
    Where-Object { ($_.FullName -like "*\bin") -or ($_.FullName -like "*\obj") -or ($_.FullName -like "*\pkg") -or ($_.FullName -like "*\pkgobj") }

$cleanTargets | Format-Table FullName

# $cleanTargets | ForEach-Object { Remove-Item -Path $_.FullName }

# With the previous line commented, the script will show a list of all items to be deleted
#   Uncomment the previous line to delete all found folders


Get-ChildItem -Path $cleanPath -Recurse | 
    Where-Object {$_.psIsContainer -eq $false} | 
    sort Length -Descending | 
    Format-List FullName, Length