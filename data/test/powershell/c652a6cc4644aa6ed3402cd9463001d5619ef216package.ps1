Add-Type -A System.IO.Compression.FileSystem
New-Item -ItemType Directory -Force -Path "c:\temp" 
[IO.Compression.ZipFile]::CreateFromDirectory('.', 'c:\temp\attendeefeedback.zip')

$username = 'ultimatepresenteruser'
$password = 'P@ssw0rd1'
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))

$apiUrl = "https://ultimate-presenter-staging.scm.azurewebsites.net/api/zip/site/wwwroot"
$filePath = "c:\temp\attendeefeedback.zip"
Invoke-RestMethod -Uri $apiUrl -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Method PUT -InFile $filePath -ContentType "multipart/form-data"