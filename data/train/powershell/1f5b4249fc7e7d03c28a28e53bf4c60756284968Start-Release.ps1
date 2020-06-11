<#
.Synopsis
   Triggers a release from a build for Visual Studio Release Management 2015 on premises
.DESCRIPTION
   Use this script in your builds to trigger a release in Visual Studio Release Management 2015 on premises. 
.EXAMPLE
   .\Start-Release.ps1 -ReleaseDefinition MyReleaseDefinition -ReleasePath MyPath -TargetStage Dev
.EXAMPLE
   .\Start-Release.ps1 -ReleaseDefinition MyReleaseDefinition -ReleasePath MyPath
#>
[CmdletBinding()]
[OutputType([int])]
Param (
        # The name of the release definition
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$ReleaseDefinition,

        # The name of the release path
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$ReleasePathName,

        # The build number. This is automatically set by the build.
        [Parameter(Mandatory=$false, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$BuildNumber = $env:TF_BUILD_BUILDNUMBER,

        # The target stage. Adjust the validation set acording to your values 
        # from the Administration / Manage Picklist / Stage Type in RM Client...
        [Parameter(Mandatory=$false, Position=2)]
        [ValidateSet("Dev", "Test", "QA", "Prod", "Last")]
        [string]$TargetStage = "Last",

        # The api version of the rest api. This might change with later updates.
        # Use fiddler to check the version that is used by rm client.
        [string]$ApiVersion = "6.0"
)

# Set the name of your release management server and the port (default 1000)
$serverName = "<your server fqdn>:1000"
$releaseManagementService = "http://$serverName/account/releaseManagementService/_apis/releaseManagement"
    
# Get the ReleasePathId 
$releasePaths = Invoke-RestMethod "$releaseManagementService/ReleaseDefinitionService/ListReleaseDefinitions?api-version=$ApiVersion" -UseDefaultCredentials -Method Post
$releasePathId = $releasePaths.ApplicationVersionList.ApplicationVersion | ? { $_.Name -eq $ReleasePathName } | % { $_.ReleasePathId }
    
# Get the TargetStageId
$releasePath = Invoke-RestMethod "$releaseManagementService/ConfigurationService/GetReleasePath?id=$releasePathId&api-version=$ApiVersion" -UseDefaultCredentials -Method Post
$stages = $releasePath.ReleasePath.Stages.Stage

if ($TargetStage -ne "Last") {
    $targetStageId = $stages | ? { $_.StageTypeName -eq $TargetStage } | % { $_.Id }
}else {
    $targetStageId = $stages | Select-Object -Last 1 | % { $_.Id }
}
    
# Create the release name
$releaseName = "Release: $(Get-Date -Format G)"

# Create the property bag
$deploymentPropertyBag = "{""ReleaseName"" : ""$releaseName"",""ReleaseBuild"": ""$BuildNumber"",""ReleaseBuildChangeset"" : """",""TargetStageId"": ""$targetStageId"",""ProviderHostedApp:Build"" : """",""ProviderHostedApp:BuildChangesetRange"" : ""-1,-1""}"
$propertyBag = [System.Uri]::EscapeDataString($deploymentPropertyBag)

$uri = "$releaseManagementService/OrchestratorService/InitiateRelease?releaseTemplateName=$releaseDefinition&deploymentPropertyBag=$propertyBag&api-version=6.0"
    
$result = Invoke-RestMethod -Uri $uri -Method Post -UseDefaultCredentials

if ($result.ErrorMessage) {
    throw $result.ErrorMessage
}

return $result