param(
    [Parameter (Mandatory=$True)]
    [string] $bucketName,

    [Parameter (Mandatory=$True)]
    [string] $accessKey,

    [Parameter (Mandatory=$True)]
    [string] $secretKey,
    
    [Parameter (Mandatory=$false)]
    [string] $region,

    [Parameter (Mandatory=$True)]
    [string] $saveFolder,
    
    [Parameter (Mandatory=$True)]
    [string] $saveFileName,

    [Parameter (Mandatory=$True)]
    [string] $S3FileName 
    
)

Import-Module SQLPS -DisableNameChecking
import-module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"

if(!$region) {
    $region = "ap-southeast-2"
}

$savePath = Join-Path $saveFolder $saveFileName

Read-S3Object -BucketName $bucketName -File $savePath -Key $S3FileName -AccessKey $accessKey -Region $region -SecretKey $secretKey
