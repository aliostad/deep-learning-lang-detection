<#
    .Synopsis
        This script will give message count from zap. 
    .Outputs
        Script will give number of message count from zap.
    .Example
        .\Get-MessageCount
    .Notes
        Author: Mrityunjaya Pathak
        Date : Feb 2015
        
#>

param(
 $SITEURL=$(throw "Missing filepath value"),
 $PROXY="http://localhost:8080"
)

Add-CurrentScriptFolderToPath
$ErrorActionPreference="stop"
invoke-webrequest -Uri ('http://zap/JSON/core/view/numberOfMessages?url='+ $SITEURL) -Proxy $PROXY | select -expand content | ConvertFrom-Json |sv MessageCount
$MessageCount.numberOfMessages