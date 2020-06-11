[T4Scaffolding.Scaffolder(Description = "Enter a description of SpongeBob.WebAPI.BaseController here")][CmdletBinding()]
param(        
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false
)

##############################################################
# NAMESPACE
##############################################################
$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value
$rootNamespace = $namespace
$dotIX = $namespace.LastIndexOf('.')
if($dotIX -gt 0){
	$rootNamespace = $namespace.Substring(0,$namespace.LastIndexOf('.'))
}

##############################################################
# Project Name
##############################################################
$webApiProjectName = $namespace
$coreProjectName = $rootNamespace + ".Core"

##############################################################
# Create the BaseController
##############################################################
$outputPath = "Controllers\BaseApiController"
$namespace = $webApiProjectName + ".Controllers"
$ximports = $coreProjectName + ".Interfaces.Service," + $coreProjectName + ".Model," + $coreProjectName + ".Interfaces.Validation," + $coreProjectName + ".Interfaces.Paging," + $coreProjectName + ".Common.Paging"

Add-ProjectItemViaTemplate $outputPath -Template BaseApiController `
	-Model @{Namespace = $namespace; ExtraUsings = $ximports} `
	-SuccessMessage "Added BaseController to WebAPI {0}" `
	-TemplateFolders $TemplateFolders -Project $webApiProjectName -CodeLanguage $CodeLanguage -Force:$Force