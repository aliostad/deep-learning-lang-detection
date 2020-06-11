#
# Manage_ResourceDeployment.ps1
#

Import-Module (Join-Path $PSScriptRoot "Common\Parameter.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "Common\Utility.psm1") -DisableNameChecking

Import-Module (Join-Path $PSScriptRoot "Preparation\SQLServerPreparation.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "Preparation\SqlDBPreparation.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "Preparation\ApplicationPreparation.psm1") -DisableNameChecking


$TemplateFile = '..\Templates\DeploymentTemplate.json'
$TemplateParametersFile = '..\Templates\DeploymentTemplate.param.dev.json'
$UpdatedTemplateParametersFile = '..\Templates\DeploymentTemplateUpdated.param.dev.json'

$TemplateFile = [System.IO.Path]::Combine($PSScriptRoot, $TemplateFile)
$TemplateParametersFile = [System.IO.Path]::Combine($PSScriptRoot, $TemplateParametersFile)
$UpdatedTemplateParametersFile = [System.IO.Path]::Combine($PSScriptRoot, $UpdatedTemplateParametersFile)

$SqlDBDeploymentTemplatePath = "..\Templates\MainTemplate\SqlDB\SqlDBDeploymentTemplate.json"
$SqlDBDeploymentTemplatePath = [System.IO.Path]::Combine($PSScriptRoot, $SqlDBDeploymentTemplatePath)

$SqlDBParameterTemplatePath = "..\Templates\MainTemplate\SqlDB\SqlDBDeploymentTemplate.param.{0}.json" -f $DeploymentConfig
$SqlDBParameterTemplatePath = [System.IO.Path]::Combine($PSScriptRoot, $SqlDBParameterTemplatePath)

$SqlDBUpdatedParameterTemplatePath = "..\Templates\MainTemplate\SqlDB\SqlDBDeploymentTemplateUpdated.param.{0}.json" -f $DeploymentConfig
$SqlDBUpdatedParameterTemplatePath = [System.IO.Path]::Combine($PSScriptRoot, $SqlDBUpdatedParameterTemplatePath)

$ApplicationDeploymentTemplatePath = [System.IO.Path]::Combine($PSScriptRoot, "..\Templates\MainTemplate\Application\ApplicationDeploymentTemplate.json")
$ApplicationDeploymentParameterTemplatePath = [System.IO.Path]::Combine($PSScriptRoot, "..\Templates\MainTemplate\Application\ApplicationDeploymentTemplate.param.{0}.json") -f $DeploymentConfig
$ApplicationDeploymentUpdatedParameterTemplatePath = [System.IO.Path]::Combine($PSScriptRoot, "..\Templates\MainTemplate\Application\ApplicationDeploymentTemplateUpdated.param.{0}.json") -f $DeploymentConfig


<#
	.Synopsis
	Login the RM account and select subscription.
#>
function Execute-SelectSubscription{
	Login-AzureRmAccount
	Select-AzureSubscription -SubscriptionId $SubscriptionId
}

<#
	.Synopsis
	Create DB resourcegroup.
#>
function Create-DBResourceGroup{

	New-AzureRmResourceGroup -Name $DBResourceGroupName `
					   -Location $Location `
						-Force -Verbose
}

# Create or update the resource group using the specified template file and template parameters file
#Switch-AzureMode AzureResourceManager

# Action region

# Select subscription
Execute-SelectSubscription

# Create DB resource group
Create-DBResourceGroup

# Create SQL server deployment
Create-SQLServerDeployment -ParameterFilePath $TemplateParametersFile -UpdateParameterFilePath $UpdatedTemplateParametersFile -TemplateFilePath $TemplateFile -SqlServerResourceGroupName $DBResourceGroupName

# Execute the following upgrade separately if possible to avoid long waiting time and any intermittent issues during the course of time.
# Upgrade Sql server to version 12.0
Upgrade-SqlServer -SqlServerResourceGroupName $DBResourceGroupName -SqlServerName $SqlServerName -TargetSqlServerVersion $TargetSqlServerUpgradeVersion

# Create Sql DB deployment
Create-SqlDBDeployment -ParameterFilePath $SqlDBParameterTemplatePath -UpdateParameterFilePath $SqlDBUpdatedParameterTemplatePath -TemplateFilePath $SqlDBDeploymentTemplatePath -SqlDBResourceGroupName $DBResourceGroupName

# Create Application deployment
Create-ApplicationDeployment -ParameterFilePath $ApplicationDeploymentParameterTemplatePath -UpdateParameterFilePath $ApplicationDeploymentUpdatedParameterTemplatePath -TemplateFilePath $ApplicationDeploymentTemplatePath -ApplicationResourceGroupName $DBResourceGroupName
