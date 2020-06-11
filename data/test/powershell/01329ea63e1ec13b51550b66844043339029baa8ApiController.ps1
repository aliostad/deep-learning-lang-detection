[T4Scaffolding.Scaffolder(Description = "This Scaffolder create an API Controller")][CmdletBinding()]
param(        
    [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][string]$ApiControllerName,
    [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][string]$ModelType,
    [string]$DbContextType,
    [string]$Project,
    [string]$CodeLanguage,
    [string[]]$TemplateFolders,
    [switch]$Force = $false,
	[switch]$Repository = $false,
    [switch]$UseIoC = $false
)

$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value


if ($Repository) {
	if(!$DbContextType) { $DbContextType = [System.Text.RegularExpressions.Regex]::Replace((Get-Project $Project).Name, "[^a-zA-Z0-9]", "") + "Context" }
	Scaffold Repository -ModelType $ModelType -DbContextType $DbContextType -Project $Project -CodeLanguage $CodeLanguage -Force:$Force -BlockUi
}

$templateName = if($Repository) { "WebApiWithRepositoryTemplate" } else { "ApiControllerTemplate" }
Add-ProjectItemViaTemplate "Controllers\$ApiControllerName" -Template $templateName `
	-Model @{ 
		Namespace = $namespace; 
		ApiControllerName = $ApiControllerName; 
		ModelType = $ModelType;
		UseIoC = [Boolean]$UseIoC;
	} -SuccessMessage "Added WebApi output at {0}" `
	-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force