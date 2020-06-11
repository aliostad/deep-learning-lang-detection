param( [string]$api_key, [string]$api_password)

$source = "https://github.com/CenturyLinkCloud/clc/raw/master/src/dist/clc-cli.exe"
$destination = "c:\windows\system32\clc-cli.exe"
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($source,$destination)


$ini = @"
;
; This configuration automatically created by the CenturyLink Cloud cli installer
;

[global]
V1_API_KEY=$api_key
V1_API_PASSWD=$api_password

;V2_API_USERNAME=
;V2_API_PASSWD=

;blueprint_ftp_url=ftp://user:password@ftp_fqdn

"@

New-Item -ItemType Directory -Force -Path $env:programdata"\clc"
$ini | Out-File $env:programdata"\clc\clc.ini" -encoding ascii

