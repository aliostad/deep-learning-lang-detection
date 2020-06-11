Write-Host "Launch export " -ForegroundColor    Yellow  

# Load SharePoint powershell commands  
Add-PSSnapin "microsoft.sharepoint.powershell" -ErrorAction SilentlyContinue  
cls  

Write-Host "Example: Export-SPWeb -Identity “http://sp.dev/subsite” -ItemUrl “/subsite/lists/List Title here”
-path “c:\temp\tempfile.txt” " -ForegroundColor    Yellow
Write-Host
$siteUrl = Read-Host "your site url"
Write-Host
$itemUrl = Read-Host "your item url"
Write-Host
$path = Read-Host "export path"
Export-SPWeb -Identity $siteUrl -ItemUrl $itemUrl  -path $path