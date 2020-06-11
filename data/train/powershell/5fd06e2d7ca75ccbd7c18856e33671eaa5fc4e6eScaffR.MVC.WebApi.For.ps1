[T4Scaffolding.Scaffolder()][CmdletBinding()]
param(        
	[parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][string]$ModelType,
	[string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false
)

$ModelTypePluralized = Get-PluralizedWord $ModelType

$outputPath = "Areas\Api\Controllers\" + $ModelTypePluralized + "Controller"
Add-TemplateWithModel $baseProject.Name $outputPath ConcreteApiController @{ Namespace = $rootNamespace; ClassName = $ModelType; PluralizedClassName = $ModelTypePluralized } -Force:$Force $TemplateFolders

