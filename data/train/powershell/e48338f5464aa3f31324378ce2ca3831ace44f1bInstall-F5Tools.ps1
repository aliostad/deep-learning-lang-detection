#-----------------------------
#VARS
#-----------------------------
#aws creds 	
$awsAccessKey	= $env:AWS_ACCESS_KEY_ID
$awsSecretKey	= $env:AWS_SECRET_KEY

$awsBucket		= $env:F5_TOOLS_SOURCE_BUCKET
$awsFolderPath	= $env:F5_TOOLS_SOURCE_FOLDER_PATH
$appInstFile	= $env:F5_TOOLS_INST_FILE

#-----------------------------

#-----------------------------
#MAIN
#-----------------------------
Set-AWSCredentials -AccessKey $awsAccessKey -SecretKey $awsSecretKey

write-Host "F5_TOOLS:  Starting F5 Tools Download & Install"

$downLoadDir	= "c:\RSDownloads"
$instLogDir		= "c:\RSDownloads\Logs"

$downLoadPath	= $downLoadDir + "\" + $awsFolderPath.replace("/","\") + "\" 

write-host "F5_TOOLS:  Destination Directory - $downLoadPath"
if(!(test-path $downLoadPath)){new-item $downloadPath -itemtype Directory -force}
if(!(test-path $instLogDir)){new-item $instLogDir -itemtype Directory -force}

#download all source files
$srcFolderPath = $awsBucket + "/" + $awsFolderPath

write-host "F5_TOOLS:  Download Bucket - $awsBucket"
write-host "F5_TOOLS:  Folder Path - $awsFolderPath"
write-host "F5_TOOLS:  Destination - $downloadPath"

$awsKeyPrefix	= $awsFolderPath

read-S3Object -BucketName $awsBucket -KeyPrefix $awsKeyPrefix -Folder $downLoadPath

write-host "F5_TOOLS: Finished Download"
write-host "F5_TOOLS:  Starting $appName install"

$instToRun = $downLoadPath + $appInstFile
$instLogFile = $instLogDir + "\F5_Tools_install.log"

write-host "F5_TOOLS:  Source File - $instToRun"

$arguments = @()
$arguments += "/i"
$arguments += "`"$instToRun`""
$arguments += "ALLUSERS=`"1`""
$arguments += "REBOOT=`"Suppress`""
$arguments += "/qb"
$arguments += "/lv*"
$arguments += "`"$instLogFile`""

write-host "F5_TOOLS`: File - $appInstFile"

Write-Host "F5_TOOLS:  Starting MSIEXEC - $appInstFile - $instToRun"
Start-Process "msiexec.exe" -ArgumentList $arguments -Wait    

write-host "F5_TOOLS:  Install exit code - $lastexitcode"
write-host "F5_TOOLS:  Finished installing $appName"

Write-Host "F5_TOOLS:  Registering F5 iControll SnapIn"
Set-Location "C:\Program Files (x86)\F5 Networks\iControlSnapIn\"
. ".\setupSnapIn.ps1"