$rc_api_controller = "rc_api"
$env_api_controller = "env_api"

<#
.Synopsis
	Creates new release candidate
\#>
function Create-Candidate([string]$server, [string]$product, [string]$version, [string]$state, [string]$scipt_file) {
    $result = .\curl -s -w "|%{http_code}" --data "State=${state}&VersionNumber=${version}&ProductName=${product}" "${server}/ReleaseCandidateAPI/Create"
    Check-Success $result
    $result = .\curl -s -w "|%{http_code}" --upload-file $scipt_file "${server}/${rc_api_controller}/AttachScript/${product}-${version}"   
    if (Check-Success $result) {
        Write-Host "Release candidate $version created successfully"             
    }
}

<#
.Synopsis
	Updates the state of a release candidate
\#>
function Update-CandidateState([string]$server, [string]$version, [string]$state) {
    $result = .\curl -s -w "|%{http_code}" --data "State=${state}" "${server}/${rc_api_controller}/UpdateState/${version}"    
    if (Check-Success $result) {
        Write-Host "State of release candidate $version changed to $state"
    }
}  


<#
.Synopsis
    Lists top n recent release candidates	
\#>
function List-Candidates([string]$server) {
    $result = .\curl -s "${server}/${rc_api_controller}/List"    
    return $result    
}

<#
.Synopsis
    Gets the version deployed to environments
\#>
function List-Environments([string]$server) {
    $result = .\curl -s "${server}/${env_api_controller}/List"    
    return $result    
}


<#
.Synopsis
	Updates the state of a release candidate
\#>
function Update-CandidateDeployment([string]$server, [string]$version, [string]$environment, [bool]$success) {
    $result = .\curl -s -w "|%{http_code}" --data "Environment=${environment}&Success=${success}" "${server}/${rc_api_controller}/MarkAsDeployed/${version}"    
    if (Check-Success $result) {
        Write-Host "Release candidate $version marked as deployed to $environment environment"
    }
}

function Check-Success($curl_output) {
    if ($curl_output.GetType().Name -ne "String") {
        $message = ""
        $curl_output | ForEach-Object { $message = $message + $_ + "`r`n" }
        Write-Error $message 
        return $false       
    } else {    
        $parts = $curl_output.split("|")
        $code = $parts[1]
        $message = $parts[0]
        if ($code -eq "500") {
            throw $message
        } else {
            return $true
        }
    }    
}  

<#
.Synopsis
	Attaches a custom document
\#>
function Add-Document([string]$server, [string]$version, [string]$document_file_name, [string]$content_type) {
	$result = .\curl -s -w "|%{http_code}" --upload-file $document_file_name "${server}/${rc_api_controller}/AttachDocument/${version}?documentName=${document_file_name}&contentType=${content_type}"       
    if (Check-Success $result) {
        Write-Host "Document $document_file_name successfully attached to candidate $version"             
    }
}

<#
.Synopsis
    Gets a custom document
\#>
function Get-Document([string]$server, [string]$version, [string]$document_file_name) {
    $result = .\curl -s -w "|%{http_code}" "${server}/${rc_api_controller}/GetDocument/${version}?documentName=${document_file_name}"    
    return $result    
}

<#
.Synopsis
	Attaches release notes
\#>
function Add-ReleaseNotes([string]$server, [string]$version, [string]$release_notes_file) {
	$result = .\curl -s -w "|%{http_code}" --upload-file $release_notes_file "${server}/${rc_api_controller}/AttachReleaseNotes/${version}"       
    if (Check-Success $result) {
        Write-Host "Release notes successfully attached to candidate $version"             
    }
}

<#
.Synopsis
    Gets the release notes
\#>
function Get-ReleaseNotes([string]$server, [string]$version) {
    $result = .\curl -s "${server}/${rc_api_controller}/GetReleaseNotes/${version}"    
    return $result    
}