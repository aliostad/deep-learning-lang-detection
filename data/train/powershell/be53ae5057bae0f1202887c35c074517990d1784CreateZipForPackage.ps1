param(
[String]$source, [String]$zipfile, [String]$whichProject, [String]$whichEnvironment
)

$username = "builduser"
$password = "ky1ttk#1"
$securePath = "C:\Builds\Scripts\secure.text"
$uiLatestServers = @("10.0.201.241")
$apiLatestServers = @("10.0.201.240")
$apiLatestMongoString = "mongodb://10.0.12.107:27117/DigitalFleetLatest"
$apiProductionMongoString = "mongodb://10.0.12.107:27117/DigitalFleet"

function update-webconfig([String] $path, [String] $version){
Write-Host ------- Webconfig update ---------
Write-Host $path : $version
$webConfig = $path
$doc = (gc $webConfig) -as [xml]
$doc.SelectSingleNode('//appSettings/add[@key="buildversion"]/@value').'#text' = $version
$doc.SelectSingleNode('//appSettings/add[@key="buildenvironment"]/@value').'#text' = $whichEnvironment

if($whichProject -eq "API" -and $whichEnvironment -eq "latest"){
$doc.SelectSingleNode('//appSettings/add[@key="SeedDatabaseWithExamples"]/@value').'#text' = 'true'
Write-Output "Setting Mongo connection to : $apiLatestMongoString"
$doc.SelectSingleNode('//connectionStrings/add[@name="Mongo"]/@connectionString').'#text' = $apiLatestMongoString
}

if($whichProject -eq "API" -and $whichEnvironment -eq "production"){
$doc.SelectSingleNode('//appSettings/add[@key="SeedDatabaseWithExamples"]/@value').'#text' = 'false'
Write-Output "Setting Mongo connection to : $apiLatestMongoString"
$doc.SelectSingleNode('//connectionStrings/add[@name="Mongo"]/@connectionString').'#text' = $apiProductionMongoString
}
$doc.Save($webConfig)
}

function update-servers([String] $source, [String] $destination){
Write-Output "updating server | $whichProject | source: $source | destination: $destination"

Remove-Item -recurse $destination\* -Force
Copy-Item -Path $source\* -Destination $destination\ -recurse -Force
}

function setup-credentials([String] $destination){
try{
net use "$destination" "$password" /USER:"$username"
}Catch{
Write-Output "Credentials already setup"
}
} 

function get-version{
Write-Host "getting version for $whichProject"
switch($whichProject.ToLower()){
api{return [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$source\bin\Digital.Api.dll").FileVersion}
ui{return [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$source\bin\Digital.UI.dll").FileVersion}
default{
Write-Output "could not get version for $whichProject"
exit(1)
}
}
}

function get-zipLocation([String] $versionNumber){
Write-Host "getting zip destination for $whichProject"
switch($whichProject.ToLower()){
api{return $zipfile + "\API-$versionNumber.zip"}
ui{return $zipfile + "\UI-$versionNumber.zip"}
default{
Write-Output "could not create zip destination for $whichProject"
exit(1)
}
}
}

function get-apiserverList{
switch($whichEnvironment.ToLower()){
latest{return $apiLatestServers}
#production{return $apiProductionServers}
default{
Write-Output "could not get api server list for $whichProject"
exit(1)
}
}
}

function get-uiserverList{
switch($whichEnvironment.ToLower()){
latest{return $uiLatestServers}
#production{return $apiProductionServers}
default{
Write-Output "could not get ui server list for $whichProject"
exit(1)
}
}
}

function get-serverList{
switch($whichProject.ToLower()){
api{return get-apiserverList}
ui{return get-uiserverList}
default{
Write-Output "could not get server list for $whichProject"
exit(1)
}
}
}

function get-destinationAddress([String] $server){
switch($whichProject.ToLower()){
api{return "\\$server\Applications\Api"}
ui{return "\\$server\Applications\Web"}
default{
Write-Output "could not get destination address for $whichProject"
exit(1)
}
}
}

function create-native45zip([String] $directory, [String] $zipfile){
Add-Type -Assembly "System.IO.Compression.FileSystem" ;
Remove-Item $zipfile -Force
[System.IO.Compression.ZipFile]::CreateFromDirectory("$directory", "$zipfile") ;
}

function extract-native45zip([String] $zipfile, [String] $exportDirectory){
Add-Type -Assembly "System.IO.Compression.FileSystem" ;
[System.IO.Compression.ZipFile]::ExtractToDirectory("$zipfile", "$exportDirectory") ;
}

function create-packagefordeploy{
try{
$versionNumber = get-version
$zipFilePath = get-zipLocation $versionNumber

foreach ($server in get-serverList){

$destination = get-destinationAddress $server
setup-credentials $destination
update-webconfig "$source\Web.config" $versionNumber

.\IISReset.ps1 $server "stop"
#todo this is temp till deployment can be completed
update-servers $source $destination
.\IISReset.ps1 $server "start"

create-native45zip $source $zipFilePath
}
}Catch{
$ErrorMessage = $_.Exception.Message
Write-Output $ErrorMessage
exit(1)
}
}

create-packagefordeploy