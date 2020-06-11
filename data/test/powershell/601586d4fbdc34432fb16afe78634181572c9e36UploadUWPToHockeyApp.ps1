 Param(
     [string]$HockeyAppAppID, 
     [string]$HockeyAppApiToken
 )
 
$zipFile = Get-Item *.zip | Select-Object -first 1
Write-Host "Zip file found to upload $($zipFile)"

$create_url = "https://rink.hockeyapp.net/api/2/apps/$HockeyAppAppID/app_versions/new"
 
$zip = $zipFile.BaseName
$version = $zip.subString(0,$zip.LastIndexOf("_"))
$version = $version.subString(0,$version.LastIndexOf("_"))
$version = $version.subString($version.LastIndexOf("_")+1)
Write-Host "Extracted version from zip file $($version)"
 
$response = Invoke-RestMethod -Method POST -Uri $create_url  -Header @{ "X-HockeyAppToken" = $HockeyAppApiToken } -Body @{bundle_version = $Version}
 
$update_url = "https://rink.hockeyapp.net/api/2/apps/$($HockeyAppAppID)/app_versions/$($response.id)"
 

$fileBin = [IO.File]::ReadAllBytes($zipFile)
$enc = [System.Text.Encoding]::GetEncoding("ISO-8859-1")
$fileEnc = $enc.GetString($fileBin)
$boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"

$bodyLines = (
    "--$boundary",
	"content-transfer-encoding: base64",
	"Content-Disposition: form-data; content-transfer-encoding: `"base64`"; name=`"ipa`"; filename=`" [System.IO.Path]::GetFileName $zipFile`"$LF",$fileEnc,
    "--$boundary",
    "Content-Disposition: form-data; name=`"status`"$LF","2",
    "--$boundary--$LF") -join $LF
	
Invoke-RestMethod -Uri $update_url -Method PUT -Headers @{ "X-HockeyAppToken" = $HockeyAppApiToken } -ContentType "multipart/form-data; boundary=`"$boundary`""  -Body $bodyLines
