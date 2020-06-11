Param(
  [String]$MapToBuild,
  [String]$BuildServerMode,
  [String]$nugetPullApiUrl
)

[String]$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
[String]$parent = Split-Path -Parent $scriptDirectory

$nugetPullApiUrlArgs = ""
if(![System.String]::IsNullOrEmpty($nugetPullApiUrl)) {
    $nugetPullApiUrlArgs = "-n $nugetPullApiUrl"
}
if([System.String]::IsNullOrEmpty($BuildServerMode)) {
    $BuildServerMode = $false
}

$rootPath = Split-Path -Parent $parent
$workflowToolsPath = "$rootPath\Binaries\Tools\WorkFlow"
$toolsWorkflowBuilderExe = "$workflowToolsPath\SAHL.Tools.Workflow.Builder.exe"

$filter = '*.x2p'
if (![System.String]::IsNullOrEmpty($MapToBuild))
{
    $filter = $MapToBuild+'.x2p'
}

$allMaps = @(Get-ChildItem -Path $scriptDirectory -include $filter -Recurse)
$workflowMaps = [System.String]::Join(",", $allMaps)
& $toolsWorkflowBuilderExe -m "$workflowMaps" -b $BuildServerMode $nugetPullApiUrlArgs